#' @importFrom foreach getErrorIndex getErrorValue getResult makeAccum
#' @importFrom iterators iter
#' @importFrom future future resolve value Future getGlobalsAndPackages FutureError
#' @importFrom parallel splitIndices
#' @importFrom utils head capture.output
#' @importFrom globals globalsByName
#  ## Just a dummy import to please 'R CMD check'
#' @import future.apply
#' @importFrom utils capture.output
doFuture2 <- function(obj, expr, envir, data) {   #nolint
  stop_if_not(inherits(obj, "foreach"))
  stop_if_not(inherits(envir, "environment"))

  debug <- debug0 <- getOption("doFuture.debug")
  verbose <- isTRUE(obj[["verbose"]])
  if (verbose) {
    options(doFuture.debug = TRUE)
    debug <- TRUE
  } else {
    debug <- isTRUE(debug)
  }
  if (debug) {
    mdebug_push("doFuture2() used by %dofuture% ...")
    on.exit({
      mdebug_pop()
      options(doFuture.debug = debug0)
    })
  }


  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## 1. Input from foreach
  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## Setup
  it <- iter(obj)
  
  if (debug) mdebugf_push("iterators::as.list() on %s ...", class(it)[1])
  if (verbose) {
    out <- capture.output({
      args_list <- as.list(it)
    })
    mdebug(paste(out, collapse = "\n"), debug = verbose)
  } else {
    args_list <- as.list(it)
  }
  if (debug) mdebug_pop()
  
  accumulator <- makeAccum(it)
  options <- obj[["options"]]
  unknown <- setdiff(names(options), "future")
  if (length(unknown) > 0L) {
    stop(sprintf("Unknown foreach() arguments: %s",
         paste(sQuote(sprintf(".options.%s", unknown)), collapse = ", ")))
  }
  options <- options[["future"]]

  if (!isTRUE(obj$useForeachArguments)) {
    if (!is.null(obj$export)) {
      stop("foreach() does not support argument '.export' when using %dofuture%. Use .options.future = list(globals = structure(..., add = ...)) instead")
    } else if (!is.null(obj$noexport)) {
      stop("foreach() does not support argument '.noexport' when using %dofuture%. Use .options.future = list(globals = structure(..., ignore = ...)) instead")
    } else if (!is.null(obj$packages)) {
      stop("foreach() does not support argument '.packages' when using %dofuture%. Use .options.future = list(packages = ...) instead")
    }
  }

  ## Support %globals%, %packages%, %seed%, ...
  opts <- getOption("future.disposable", NULL)
  if (length(opts) > 0) {
    for (name in names(opts)) {
      options[[name]] <- opts[[name]]
    }
    if (!identical(attr(opts, "dispose"), FALSE)) {
      options(future.disposable = NULL)
    }
  }

  error_handling <- obj$errorHandling
  if (!identical(error_handling, "stop")) {
    errors <- "foreach"
  } else {
    errors <- options[["errors"]]
    if (is.null(errors)) {
      errors <- "future"
    } else if (is.character(errors)) {
      if (length(errors) != 1L) {
        stop(sprintf("Element 'errors' of '.options.future' should be of length one: [n = %d] %s", length(errors), paste(sQuote(errors), collapse = ", ")))
      }
      if (! errors %in% c("future", "foreach")) {
        stop(sprintf("Unknown value of '.options.future' element 'errors': %s", sQuote(errors)))
      }
    } else {
      stop("Unknown type of '.options.future' element 'errors': ", mode(errors))
    }
  }


  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## 2. Load balancing ("chunking")
  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## (a) .options.future = list(chunk.size = <numeric>)
  ##      cf. future_lapply(..., future.chunk.size)
  chunk.size <- options[["chunk.size"]]

  ## (b) .options.future = list(scheduling = <numeric>)
  ##      cf. future_lapply(..., future.scheduling)
  scheduling <- options[["scheduling"]]
  
  if (is.null(chunk.size) && is.null(scheduling)) {
    scheduling <- 1.0
  }
  

  nX <- length(args_list)
  chunks <- makeChunks(nbrOfElements = nX,
                       nbrOfWorkers = nbrOfWorkers(),
                       future.scheduling = scheduling,
                       future.chunk.size = chunk.size)
  if (debug) mdebugf("Number of chunks: %d", length(chunks))

  ## Process elements in a custom order?
  ordering <- attr(chunks, "ordering")
  if (!is.null(ordering)) {
    if (debug) mdebugf("Index remapping (attribute 'ordering'): [n = %d] %s", length(ordering), hpaste(ordering))
    chunks <- lapply(chunks, FUN = function(idxs) .subset(ordering, idxs))
  }


  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## 3. Prepare for creating futures
  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## Relay standard output or conditions?
  stdout <- options[["stdout"]]
  if (is.null(stdout)) {
    stdout <- eval(formals(future)$stdout)
  }

  if ("conditions" %in% names(options)) {
    conditions <- options[["conditions"]]
  } else {
    conditions <- eval(formals(future)$conditions)
  }

  ## Drop captured standard output and conditions as soon as they have
  ## been relayed?
  if (isTRUE(stdout)) stdout <- structure(stdout, drop = TRUE)
  if (length(conditions) > 0) conditions <- structure(conditions, drop = TRUE)

  nchunks <- length(chunks)

  ## Adjust option 'future.globals.maxSize' to account for the fact that more
  ## than one element is processed per future.  The adjustment is done by
  ## scaling up the limit by the number of elements in the chunk.  This is
  ## a "good enough" approach.
  ## (https://github.com/futureverse/future.apply/issues/8,
  ##  https://github.com/futureverse/doFuture/issues/26)
  globals.maxSize <- getOption("future.globals.maxSize")
  if (nchunks > 1 && !is.null(globals.maxSize) && globals.maxSize < +Inf) {
    globals.maxSize.default <- globals.maxSize
    if (is.null(globals.maxSize.default)) globals.maxSize.default <- 500 * 1024^2

    globals.maxSize.adjusted <- nchunks * globals.maxSize.default
    options(future.globals.maxSize = globals.maxSize.adjusted)
    on.exit(options(future.globals.maxSize = globals.maxSize), add = TRUE)

    ## Adjust expression 'expr' such that the non-adjusted maxSize is used
    ## within each future
    expr <- bquote_apply(tmpl_expr_options)

    if (debug) {
      mdebug_push("Rescaling option 'future.globals.maxSize' to account for the number of elements processed per chunk:")
      mdebugf("Number of chunks: %d", nchunks)
      mdebugf("globals.maxSize (original): %.0f bytes", globals.maxSize.default)
      mdebugf("globals.maxSize (adjusted): %.0f bytes", globals.maxSize.adjusted)
      mdebug("R expression (adjusted):")
      mprint(expr)
      mdebug_pop(NA)
    }
  } else {
    globals.maxSize.adjusted <- NULL
  }


  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## 4. Reproducible RNG
  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  seed <- options[["seed"]]
  if (is.null(seed)) seed <- eval(formals(future)$seed)
  if (debug) mdebugf("seed = %s", deparse(seed))

  seeds <- make_rng_seeds(nX, seed = seed)

  ## Future expression (with or without setting the RNG state) and
  ## pass possibly tweaked 'seed' to future()
  if (is.null(seeds)) {
    stop_if_not(is.null(seed) || isFALSE(seed))
  } else {
    if (debug) {
      mdebug("RNG seeds:")
      mstr(seeds)
    }
    ## If RNG seeds are used (given or generated), make sure to reset
    ## the RNG state afterward
    oseed <- next_random_seed()    
    on.exit(set_random_seed(oseed), add = TRUE)
    ## As seed=FALSE but without the RNG check
    seed <- NULL
  }
  if (debug) mdebugf("seed = %s", deparse(seed))
  

  ## Are there RNG-check settings specific for doFuture?
  onMisuse <- getOption("doFuture.rng.onMisuse", NULL)
  if (!is.null(onMisuse)) {
    if (onMisuse == "ignore") {
      seed <- NULL
    } else {
      oldOnMisuse <- getOption("future.rng.onMisuse")
      options(future.rng.onMisuse = onMisuse)
      on.exit(options(future.rng.onMisuse = oldOnMisuse), add = TRUE)
    }
  }
  if (debug) mdebugf("seed = %s", deparse(seed))


  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## 5. Construct future expression from %dofuture% expression
  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if (debug) {
    mdebug_push("%dofuture% R expression:")
    mprint(expr)
    mdebug_pop(NA)
  }

  ## WORKAROUND: foreach::times() passes an empty string in 'argnames'
  argnames <- it$argnames
  argnames <- argnames[nzchar(argnames)]
  if (debug) {
    mdebugf("foreach() iterator arguments: [%d] %s",
           length(argnames), paste(sQuote(argnames), collapse = ", "))
  }
  
  ## The iterator arguments in 'argnames' should be exported as globals, which
  ## they also are as part of the 'globals = globals_ii' list that is passed
  ## to each future() call.  However, getGlobalsAndPackages(..., globals = TRUE)
  ## below requires that they are found.  If not, an error is produced.
  ## As a workaround, we will inject them as dummy variables in the expression
  ## inspected, making them look like local variables.
  if (debug) {
    mdebugf("Dummy globals (as locals): [%d] %s",
           length(argnames), paste(sQuote(argnames), collapse = ", "))
  }
  dummy_globals <- NULL
  for (kk in seq_along(argnames)) {
    name <- as.symbol(argnames[kk])  #nolint
    dummy_globals <- bquote_apply(tmpl_dummy_globals)
  }

  ## With foreach error handling?
  if (!is.null(errors) && errors != "future") {
    if (debug) mdebugf("use foreach error handling: %s", sQuote(errors))
    expr <- bquote(tryCatch(.(expr), error = identity))
  }

  ## With or without RNG?
  if (is.null(seeds)) {
    seed_assignment <- NULL
  } else {
    seed_assignment <- quote(assign(".Random.seed", ...future.seeds_ii[[jj]], envir = globalenv(), inherits = FALSE))
  }
  expr_mapreduce <- bquote_apply(tmpl_expr_with_or_without_rng)
  rm(list = c("dummy_globals", "seed_assignment")) ## Not needed anymore

  if (debug) {
    mdebug("R expression (map-reduce expression adjusted for RNG):")
    mprint(expr_mapreduce)
  }


  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## 6. Identify globals and packages
  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if (debug) mdebug_push("Identifying globals and packages ...")

  globals <- options[["globals"]]
  if (is.null(globals)) globals <- TRUE
  
  packages <- c(options[["packages"]], obj$packages)
  
  ## Environment from where to search for globals
  globals_envir <- new.env(parent = envir)

  add <- attr(globals, "add", exact = TRUE)

  assign("...future.x_ii", 42, envir = globals_envir, inherits = FALSE)
  add <- c(add, "...future.x_ii")

  ignore <- attr(globals, "ignore", exact = TRUE)
  ignore <- c(ignore, argnames)

  if (is.character(globals)) {
     globals <- setdiff(unique(c(globals, add)), ignore)
  } else {
    attr(globals, "add") <- add
    attr(globals, "ignore") <- ignore
  }

  if (debug) {
    mdebug("Argument 'globals':\n")
    mstr(globals)
    mdebug("R expression (map-reduce expression searched for globals):")
    mprint(expr_mapreduce)
  }

  gp <- getGlobalsAndPackages(expr_mapreduce, envir = globals_envir, globals = globals, packages = packages)
  globals_mapreduce <- gp$globals
  packages <- unique(c(gp$packages, packages))
  expr_mapreduce <- gp$expr
  rm(list = c("gp", "globals_envir")) ## Not needed anymore


  ## Search also %dofuture% expression alone, to pick up things
  ## like a <- a + 1, where 'a' is a global
  ## This was added to make future with evalFuture() backward compatible
  ## with previous versions of the 'future' package /HB 2025-02-08
  if (getOption("doFuture.globals.scanVanillaExpression", TRUE)) {
    if (debug) {
      mdebug("R expression (%dofuture% expression searched for globals):")
      mprint(expr)
    }
  
    gp <- getGlobalsAndPackages(expr, envir = envir, globals = globals, packages = packages)
    globals <- gp$globals
    diff <- setdiff(names(globals), names(globals_mapreduce))
    if (debug) {
      mdebug("Globals in %dofuture% R expression not in map-reduce expression:")
      mdebugf("- Appending %d globals only found in the vanilla %%dofuture%% expression: %s", length(diff), paste(sQuote(diff), collapse = ", "))
    }
    if (length(diff) > 0) {
      globals_mapreduce <- c(globals_mapreduce, globals[diff])
    }
  }

  globals <- globals_mapreduce

  if (debug) {
    mdebugf("- globals: [%d] %s", length(globals),
           paste(sQuote(names(globals)), collapse = ", "))
    mstr(globals)
  }
  
  ## Also make sure we've got our in-house '...future.x_ii' covered.
  stop_if_not("...future.x_ii" %in% names(globals),
            !any(duplicated(names(globals))),
            !any(duplicated(packages)))

  ## Have the future backend/framework also handle the required 'doFuture'
  ## package.  That way we will get a more informative error message in
  ## case it is missing.
  packages <- unique(c("doFuture", packages))
  
  if (debug) {
    mdebugf("- packages: [%d] %s", length(packages),
           paste(sQuote(packages), collapse = ", "))
  
    mdebug_pop()
  }

  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## 7. Creating futures
  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  label <- options[["label"]]
  if (is.null(label)) {
    label <- "doFuture2-%s"
  } else {
    stopifnot(length(label) == 1L, is.character(label))
    ## WORKAROUND: futurize (== 0.3.0) tweak
    if (label == "fz:foreach::%:%-%d") label <- "fz:foreach::%%:%%-%d"
  }
  labels <- sprintf(label, seq_len(nchunks))
  fs <- tryCatch({
    if (debug) {
      mdebugf_push("Launching %d futures (chunks) ...", nchunks)
      on.exit(mdebugf_pop())
    }

    fs <- vector("list", length = nchunks)

    for (ii in seq_along(chunks)) {
      chunk <- chunks[[ii]]
      if (debug) {
        mdebugf_push("Chunk #%d of %d ...", ii, length(chunks))
        mdebugf("Chunk indices: [n=%d] %s", length(chunk), hpaste(chunk))
      }
      ## Subsetting outside future is more efficient
      globals_ii <- globals
      packages_ii <- packages
      args_list_ii <- args_list[chunk]
      globals_ii[["...future.x_ii"]] <- args_list_ii
  
      if (debug) mdebugf_push("Finding globals in 'args_list' for chunk #%d ...", ii)
      ## Search for globals in 'args_list_ii':
      gp <- getGlobalsAndPackages(args_list_ii, envir = envir, globals = TRUE)
      globals_X <- gp$globals
      packages_X <- gp$packages
      gp <- NULL
  
      if (debug) {
        info <- if (length(globals_X) == 0) "" else hpaste(sQuote(names(globals_X)))
        mdebugf("Globals: [n=%d] %s", length(globals_X), info)
        info <- if (length(packages_X) == 0) "" else hpaste(sQuote(packages))
        mdebugf("Packages: [n=%d] %s", length(packages_X), info)
      }
    
      ## Export also globals found in 'args_list_ii'
      if (length(globals_X) > 0L) {
        reserved <- intersect(c("...future.FUN", "...future.x_ii"), names(globals_X))
        if (length(reserved) > 0) {
          mdebugf_pop() ## "Finding globals in 'args_list' for chunk #%d ..."
          mdebugf_pop() ## "Chunk #%d of %d ..."
          stop("Detected globals in 'args_list' using reserved variable names: ",
               paste(sQuote(reserved), collapse = ", "))
        }
        globals_ii <- unique(c(globals_ii, globals_X))
  
        ## Packages needed due to globals in 'args_list_ii'?
        if (length(packages_X) > 0L)
          packages_ii <- unique(c(packages_ii, packages_X))
      }
      
      rm(list = c("globals_X", "packages_X"))
      
      if (debug) mdebug_pop() ## "Finding globals in 'args_list' for chunk #%d ..."
  
      rm(list = "args_list_ii")
      
      if (!is.null(globals.maxSize.adjusted)) {
        globals_ii <- c(globals_ii, ...future.globals.maxSize = globals.maxSize)
      }
  
      ## Using RNG seeds or not?
      if (is.null(seeds)) {
        if (debug) mdebug("seeds: <none>")
      } else {
        if (debug) mdebugf("seeds: [n=%d] <seeds>", length(chunk))
        globals_ii[["...future.seeds_ii"]] <- seeds[chunk]
        stop_if_not(length(seeds[chunk]) > 0, is.list(seeds[chunk]))
      }
  
      fs[[ii]] <- future(
        expr_mapreduce, substitute = FALSE,
        envir = envir,
        globals = globals_ii,
        packages = packages_ii,
        seed = seed,
        stdout = stdout,
        conditions = conditions,
        label = labels[ii]
      )
  
      ## Not needed anymore
      rm(list = c("chunk", "globals_ii", "packages_ii"))
  
      if (debug) mdebug_pop() ## "Chunk #%d of %d ..."
    } ## for (ii ...)

    fs
  }, interrupt = function(int) {
    onInterrupt(int, op_name = "%dofuture%", debug = debug)
  }, error = function(e) {
    onError(e, futures = fs, debug = debug)
  }) ## tryCatch()
  rm(list = c("globals", "packages", "labels", "seeds"))
  stop_if_not(length(fs) == nchunks)


  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## 8. Resolve futures, gather their values, and reduce
  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## Resolve futures
  values <- tryCatch({
    if (debug) {
      mdebugf_push("Resolving %d futures (chunks) ...", nchunks)
      mdebug("Gathering results & relaying conditions (except errors)")
      on.exit(mdebug_pop())
    }
  
    ## Check for RngFutureCondition:s when resolving futures?
    if (isFALSE(seed)) {
      withCallingHandlers({
        values <- local({
          oopts <- options(future.rng.onMisuse.keepFuture = FALSE)
          on.exit(options(oopts))
          value(fs)
        })
      }, RngFutureCondition = function(cond) {
        ## One of "our" futures?
        idx <- NULL
        
        ## Compare future UUIDs or whole futures?
        uuid <- attr(cond, "uuid")
        if (!is.null(uuid)) {
          ## (a) Future UUIDs are available
          for (kk in seq_along(fs)) {
            if (identical(fs[[kk]]$uuid, uuid)) idx <- kk
          }
        } else {        
          ## (b) Future UUIDs are not available, use Future object?
          f <- attr(cond, "future")
          if (is.null(f)) return()
          ## Nothing to do?
          if (!isFALSE(f$seed)) return()  ## shouldn't really happen
          for (kk in seq_along(fs)) {
            if (identical(fs[[kk]], f)) idx <- kk
          }
        }
        
        ## Nothing more to do, i.e. not one of our futures?
        if (is.null(idx)) return()
  
        ## Adjust message to give instructions relevant to this package
        f <- fs[[idx]]
        label <- f$label
        if (is.null(label)) label <- "<none>"
        chunk <- chunks[[idx]]
        ordering <- attr(chunks, "ordering")
        if (!is.null(ordering)) {
          chunk <- ordering[chunk]
        }
        if (length(chunk) == 1L) {
          iterations <- sprintf("Iteration %d", chunk)
        } else {
          iterations <- seq_to_human(chunk)
          iterations <- sprintf("At least one of iterations %s", iterations)
        }
        message <- sprintf("UNRELIABLE VALUE: %s of the foreach() %%dofuture%% { ... }, part of chunk #%d (%s), unexpectedly generated random numbers without declaring so. There is a risk that those random numbers are not statistically sound and the overall results might be invalid. To fix this, specify foreach() argument '.options.future = list(seed = TRUE)'. This ensures that proper, parallel-safe random numbers are produced. To disable this check, set option 'doFuture.rng.onMisuse' to \"ignore\".", iterations, idx, sQuote(label))
        cond$message <- message
        if (inherits(cond, "warning")) {
          warning(cond)
          invokeRestart("muffleWarning")
        } else if (inherits(cond, "error")) {
          mdebugf_pop() ## "Resolving %d futures (chunks) ..."
          stop(cond)
        }
      }) ## withCallingHandlers()
    } else {
      values <- value(fs)
    }
    values
  }, interrupt = function(int) {
    onInterrupt(int, op_name = "%dofuture%", debug = debug)
  }, error = function(e) {
    onError(e, futures = fs, debug = debug)
  }) ## tryCatch()
  rm(list = "chunks")
  stop_if_not(length(values) == nchunks)

  ## Not needed anymore
  rm(list = "fs")

  if (debug) {
    mdebugf("Number of value chunks collected: %d", length(values))
  }

  if (debug) mdebugf("Reducing values from %d chunks ...", nchunks)

  if (debug) {
    mdebug("Raw results:")
    mstr(values)
  }

  results <- values
  results2 <- do.call(c, args = results)
  if (debug) {
    mdebug("Combined results:")
    mstr(results2)
  }

  ## Assertions
  if (length(results2) != length(args_list)) {
    chunk_sizes <- sapply(results, FUN = length)
    chunk_sizes <- table(chunk_sizes)
    chunk_summary <- sprintf("%d chunks with %s elements", 
        chunk_sizes, names(chunk_sizes))
    chunk_summary <- paste(chunk_summary, collapse = ", ")
    msg <- sprintf("Unexpected error in doFuture(): After gathering and merging the results 
 %d chunks into a list, the total number of elements (= %d) does not match the number of input
elements in 'X' (= %d). There were in total %d chunks and %d elements (%s)", 
        nchunks, length(results2), length(args_list), nchunks, 
        sum(chunk_sizes), chunk_summary)
    if (debug) {
        mdebug(msg)
        mprint(chunk_sizes)
        mdebug("Results before merge chunks:")
        mstr(results)
        mdebug("Results after merge chunks:")
        mstr(results2)
    }
    msg <- sprintf("%s. Example of the first few values: %s", 
        msg, paste(capture.output(str(head(results2, 3L))), 
            collapse = "\\n"))
    ex <- FutureError(msg)
    stop(ex)
  }
  values <- values2 <- results <- NULL

  ## Were elements processed in a custom order?
  if (length(results2) > 1L && !is.null(ordering)) {
    invOrdering <- vector(mode(ordering), length = nX)
    idx <- 1:nX
    invOrdering[.subset(ordering, idx)] <- idx
    rm(list = c("ordering", "idx"))
    if (debug) mdebugf("Reverse index remapping (attribute 'ordering'): [n = %d] %s", length(invOrdering), hpaste(invOrdering))
    results2 <- .subset(results2, invOrdering)
    rm(list = c("invOrdering"))
  }


  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## 10. Accumulate results
  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## Combine results (and identify errors)
  ## NOTE: This is adopted from foreach:::doSEQ()
  if (debug) mdebug_push("Accumulating results ...")
  tryCatch({
    if (verbose) {
      out <- capture.output({
        res <- accumulator(results2, tags = seq_along(results2))
      })
      void <- lapply(out, FUN = mdebug, debug = verbose)
      res
    } else {
      accumulator(results2, tags = seq_along(results2))
    }
  }, error = function(e) {
    msg <- capture.output(print(e))
    msg <- c("Failed to combine foreach() %dofuture% results, which suggests an invalid '.combine' argument. The reported error was:", msg)
    ex <- FutureError(paste(msg, collapse = "\n"))
    ex$original_error <- e
    if (debug) mdebug_pop() ## "Accumulating results ..."
    stop(ex)
  })
  rm(list = "values")
  if (debug) mdebug_pop()


  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## 11. Error handling
  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if (debug) mdebug_push("Handling errors ...")
  error_value <- getErrorValue(it)
  if (!is.null(error_value)) {
    ## Report on errors like elsewhere in the Futureverse (default)?
    if (errors == "future") {
      if (debug) mdebug_pop() ## "Handling errors ..."
      stop(error_value)
    } else {  
      ## ... or as traditionally with %dopar%, which throws an error
      ## or return the combined results
      ## NOTE: This is adopted from foreach:::doSEQ()
      if (debug) {
        mdebugf("processing errors (handler = %s)", sQuote(error_handling))
      }
      error_value <- getErrorValue(it)
      if (identical(error_handling, "stop")) {
        error_index <- getErrorIndex(it)
        msg <- sprintf('task %d failed - "%s"', error_index,
                       conditionMessage(error_value))
        if (debug) mdebug_pop() ## "Handling errors ..."
        stop(simpleError(msg, call = expr))
      }
    }
  }
  rm(list = c("expr"))
  if (debug) mdebug_pop() ## "Handling errors ..."


  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## 12. Final results
  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if (debug) mdebug_push("Extracting results ...")
  res <- getResult(it)
  if (debug) mdebug_pop()
  
  res
} ## doFuture2()


seq_to_intervals <- function(idx, ...) {
  # Clean up sequence
  idx <- as.integer(idx)
  idx <- unique(idx)
  idx <- sort(idx)

  n <- length(idx)
  if (n == 0L) {
    res <- matrix(NA_integer_, nrow=0L, ncol=2L)
    colnames(res) <- c("from", "to")
    return(res)
  }


  # Identify end points of intervals
  d <- diff(idx)
  d <- (d > 1)
  d <- which(d)
  nbrOfIntervals <- length(d) + 1

  # Allocate return matrix
  res <- matrix(NA_integer_, nrow=nbrOfIntervals, ncol=2L)
  colnames(res) <- c("from", "to")

  fromValue <- idx[1]
  toValue <- fromValue-1
  lastValue <- fromValue

  count <- 1
  for (kk in seq_along(idx)) {
    value <- idx[kk]
    if (value - lastValue > 1) {
      toValue <- lastValue
      res[count,] <- c(fromValue, toValue)
      fromValue <- value
      count <- count + 1
    }
    lastValue <- value
  }

  if (toValue < fromValue) {
    toValue <- lastValue
    res[count,] <- c(fromValue, toValue)
  }

  res
}

seq_to_human <- function(idx, tau=1L, delimiter="-", collapse=", ", ...) {
  tau <- as.integer(tau)
  data <- seq_to_intervals(idx)

  ## Nothing to do?
  n <- nrow(data)
  if (n == 0) return("")

  s <- character(length=n)

  delta <- data[,2L] - data[,1L]

  ## Individual values
  idxs <- which(delta == 0)
  if (length(idxs) > 0L) {
    s[idxs] <- as.character(data[idxs,1L])
  }

  if (tau > 1) {
    if (tau == 2) {
      idxs <- which(delta == 1)
      if (length(idxs) > 0L) {
        s[idxs] <- paste(data[idxs,1L], data[idxs,2L], sep=collapse)
      }
    } else {
      idxs <- which(delta < tau)
      if (length(idxs) > 0L) {
        for (idx in idxs) {
          s[idx] <- paste(data[idx,1L]:data[idx,2L], collapse=collapse)
        }
      }
    }
  }

  ## Ranges
  idxs <- which(delta >= tau)
  if (length(idxs) > 0L) {
    s[idxs] <- paste(data[idxs,1L], data[idxs,2L], sep=delimiter)
  }

  paste(s, collapse=collapse)
}


tmpl_dummy_globals <- bquote_compile({
  .(dummy_globals)
  .(name) <- NULL
})


tmpl_expr_with_or_without_rng <- bquote_compile({
  "# doFuture():::doFuture2(): process chunk of elements"
  lapply(seq_along(...future.x_ii), FUN = function(jj) {
    ...future.x_jj <- ...future.x_ii[[jj]]  #nolint
    .(dummy_globals)
    ...future.env <- environment()          #nolint
    local({
      for (name in names(...future.x_jj)) {
        assign(name, ...future.x_jj[[name]],
               envir = ...future.env, inherits = FALSE)
      }
    })
    .(if (!is.null(seed_assignment))
    "# Parallel random-number generation"
    )
    .(seed_assignment)
    ## Note, this tryCatch() hides errors from future::value(), which
    ## is why it won't cancel all other futures automatically
    "# Evaluate the foreach expression"
    .(expr)
  })
})


tmpl_expr_options <- bquote_compile({
  "# doFuture:::doFuture2(): preserve future option"
  ...future.globals.maxSize.org <- getOption("future.globals.maxSize")
  if (!identical(...future.globals.maxSize.org, ...future.globals.maxSize)) {
    oopts <- options(future.globals.maxSize = ...future.globals.maxSize)
    on.exit(options(oopts), add = TRUE)
  }
  .(expr)
})
