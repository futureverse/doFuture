#' @importFrom foreach getErrorIndex getErrorValue getResult makeAccum
#' @importFrom iterators iter
#' @importFrom future future resolve value Future FutureError getGlobalsAndPackages
#' @importFrom parallel splitIndices
#' @importFrom utils head capture.output
#' @importFrom globals globalsByName
doFuture <- local({
  tmpl_dummy_globals <- bquote_compile({
    .(dummy_globals)
    .(name) <- NULL
  })

  tmpl_expr <- bquote_compile({
    "# doFuture():::doFuture(): Make sure that foreach uses 'doFuture'"
    "# also in nested calls                                           "
    doFuture::registerDoFuture()

    "# doFuture():::doFuture(): process chunk of elements"
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
      ## Note, this tryCatch() hides errors from future::value(), which
      ## is why it won't cancel all other futures automatically
      "# Evaluate the foreach expression, while capturing errors"
      tryCatch(.(expr), error = identity)
    })
  })

  tmpl_expr_options <- bquote_compile({
    "# doFuture:::doFuture(): preserve future option"
    ...future.globals.maxSize.org <- getOption("future.globals.maxSize")
    if (!identical(...future.globals.maxSize.org, ...future.globals.maxSize)) {
      oopts <- options(future.globals.maxSize = ...future.globals.maxSize)
      on.exit(options(oopts), add = TRUE)
    }
    .(expr)
  })


function(obj, expr, envir, data) {   #nolint
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
    mdebug_push("doFuture() used by %dopar% ...")
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
  
  ## WORKAROUND: foreach::times() passes an empty string in 'argnames'
  argnames <- it$argnames
  argnames <- argnames[nzchar(argnames)]


  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## 2. The future expression to use
  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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

  expr <- bquote_apply(tmpl_expr)

  rm(list = "dummy_globals") ## Not needed anymore

  if (debug) {
    mdebug("R expression:")
    mprint(expr)
  }


  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## 3. Identify globals and packages
  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if (debug) mdebug_push("Identifying globals and packages ...")
  
  gp <- getGlobalsAndPackages_doFuture(expr, envir = envir,
                                       export = obj$export,
                                       noexport = c(obj$noexport, argnames),
                                       packages = obj$packages,
                                       debug = debug)

  expr <- gp$expr
  globals <- gp$globals
  packages <- gp$packages
  scanForGlobals <- gp$scanForGlobals
  rm(list = "gp")
  
  ## Have the future backend/framework also handle the required 'doFuture'
  ## package.  That way we will get a more informative error message in
  ## case it is missing.
  packages <- c("doFuture", packages)
  
  if (debug) {
    mdebug("R expression:")
    mprint(expr)
    mdebugf("Globals: [%d] %s", length(globals),
           paste(sQuote(names(globals)), collapse = ", "))
    mstr(globals)
    mdebugf("Packages: [%d] %s", length(packages),
           paste(sQuote(packages), collapse = ", "))
    mdebug_pop()
  }


  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## 4. Argument '.options.future'
  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  options <- obj[["options"]][["future"]]
  
  ## Support %globals%, %packages%, ...
  opts <- getOption("future.disposable", NULL)
  if (length(opts) > 0) {
    for (name in names(opts)) {
      options[[name]] <- opts[[name]]
    }
    if (!identical(attr(opts, "dispose"), FALSE)) {
      options(future.disposable = NULL)
    }
  }


  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## 5. Load balancing ("chunking")
  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## Options:
  ## (a) .options.future = list(chunk.size = <numeric>)
  ##      cf. future_lapply(..., future.chunk.size)
  chunk.size <- options[["chunk.size"]]

  ## (b) .options.future = list(scheduling = <numeric>)
  ##      cf. future_lapply(..., future.scheduling)
  scheduling <- options[["scheduling"]]

  ## If not set, fall back to:
  ## (c) .options.multicore = list(preschedule = <logical>)
  ##      used by doParallel:::doParallelMC(), cf. mclapply(..., preschedule)
  ## (d) .options.snow      = list(preschedule = <logical>)
  ##      used by doParallel:::doParallelSNOW()
  if (is.null(chunk.size) && is.null(scheduling)) {
    preschedule <- obj[["options"]][["multicore"]][["preschedule"]]
    if (is.null(preschedule)) {
      preschedule <- obj[["options"]][["snow"]][["preschedule"]]
    }

    ## If 'preschedule', then 'scheduling' ...
    if (!is.null(preschedule)) {
      preschedule <- as.logical(preschedule)
      stop_if_not(length(preschedule) == 1L, !is.na(preschedule))
      if (preschedule) {
        scheduling <- 1.0
      } else {
        scheduling <- Inf
      }
    } else {
      ## ... otherwise, the default is to preschedule ("chunk")
      scheduling <- 1.0
    }
  }

  chunks <- makeChunks(nbrOfElements = length(args_list),
                       nbrOfWorkers = nbrOfWorkers(),
                       future.scheduling = scheduling,
                       future.chunk.size = chunk.size)
  if (debug) mdebugf("Number of chunks: %d", length(chunks))


  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## 6. Prepare for creating futures
  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## Relay standard output or conditions?
  stdout <- options[["stdout"]]
  if (is.null(stdout)) stdout <- eval(formals(Future)$stdout)

  if ("conditions" %in% names(options)) {
    conditions <- options[["conditions"]]
  } else {
    conditions <- eval(formals(future)$conditions)
  }

  ## Drop captured standard output and conditions as soon as they have
  ## been relayed?
  if (isTRUE(stdout)) {
    stdout <- structure(stdout, drop = TRUE)
  }
  if (length(conditions) > 0) {
    conditions <- structure(conditions, drop = TRUE)
  }


  nchunks <- length(chunks)
  fs <- vector("list", length = nchunks)
  if (debug) mdebugf("Number of futures (= number of chunks): %d", nchunks)

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
      mdebug_pop()
    }
  } else {
    globals.maxSize.adjusted <- NULL
  }


  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## 7. Reproducible RNG
  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## Produce a warning if random numbers are used by mistake, that is,
  ## if the RNG state is updated without having requested to use parallel RNG.
  seed <- FALSE

  ## SPECIAL CASES: If parallel RNG is taken care of by another package
  ## such as doRNG or BiocParallel package, then disable this check.
  if (".doRNG.stream" %in% obj[["argnames"]] &&
      "doRNG" %in% loadedNamespaces()) {
    ## Taken care of by the doRNG package
    seed <- NULL
  } else if (all(c("%dopar%", "BPPARAM", "BPREDO") %in% names(envir)) &&
             "BiocParallel" %in% loadedNamespaces() &&
             inherits(envir[["BPPARAM"]], "DoparParam") &&
             is.list(envir[["BPREDO"]])) {
    ## Taken care of by the BiocParallel package
    seed <- NULL
  }

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


  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## 8. Creating futures
  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  labels <- sprintf("doFuture-%s", seq_len(nchunks))
  fs <- tryCatch({
    if (debug) {
      mdebugf_push("Launching %d futures (chunks) ...", nchunks)
      on.exit(mdebugf_pop())
    }

    fs <- vector("list", length = nchunks)

    for (ii in seq_along(chunks)) {
      chunk <- chunks[[ii]]
      if (debug) mdebugf_push("Chunk #%d of %d ...", ii, length(chunks))
  
      ## Subsetting outside future is more efficient
      globals_ii <- globals
      packages_ii <- packages
      args_list_ii <- args_list[chunk]
      globals_ii[["...future.x_ii"]] <- args_list_ii
  
      if (scanForGlobals) {
        if (debug) mdebugf_push("Finding globals in 'args_list' chunk #%d ...", ii)
        ## Search for globals in 'args_list_ii':
        gp <- getGlobalsAndPackages(args_list_ii, envir = envir, globals = TRUE)
        globals_X <- gp$globals
        packages_X <- gp$packages
        gp <- NULL
  
        if (debug) {
          info <- if (length(globals_X) == 0) "" else hpaste(sQuote(names(globals_X)))
          mdebugf("Globals: [n=%d] %s", length(globals_X), info)
          info <- if (length(packages_X) == 0) "" else hpaste(sQuote(names(packages_X)))
          mdebugf("Package: [n=%d] %s", length(packages_X), info)
        }
      
        ## Export also globals found in 'args_list_ii'
        if (length(globals_X) > 0L) {
          reserved <- intersect(c("...future.FUN", "...future.x_ii"), names(globals_X))
          if (length(reserved) > 0) {
            stop("Detected globals in 'args_list' using reserved variables names: ",
                 paste(sQuote(reserved), collapse = ", "))
          }
          globals_ii <- unique(c(globals_ii, globals_X))
  
          ## Packages needed due to globals in 'args_list_ii'?
          if (length(packages_X) > 0L)
            packages_ii <- unique(c(packages_ii, packages_X))
        }
        
        rm(list = c("globals_X", "packages_X"))
      }
  
      rm(list = "args_list_ii")
      
      if (!is.null(globals.maxSize.adjusted)) {
        globals_ii <- c(globals_ii, ...future.globals.maxSize = globals.maxSize)
      }
      
      fs[[ii]] <- future(expr, substitute = FALSE, envir = envir,
                         globals = globals_ii, packages = packages_ii,
                         seed = seed,
                         stdout = stdout, conditions = conditions,
                         label = labels[ii])
  
      ## Not needed anymore
      rm(list = c("chunk", "globals_ii", "packages_ii"))
  
      if (debug) mdebug_pop()
    } ## for (ii ...)

    fs
  }, interrupt = function(int) {
    onInterrupt(int, op_name = "%dopar%", debug = debug)
  }, error = function(e) {
    onError(e, futures = fs, debug = debug)
  }) ## tryCatch()
  rm(list = c("chunks", "globals", "packages", "labels"))
  stop_if_not(length(fs) == nchunks)


  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## 9. Resolve futures, gather their values, and reduce
  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## Resolve futures
  tryCatch({
    if (debug) {
      mdebugf_push("Resolving %d futures (chunks) ...", nchunks)
      mdebug("Gathering results & relaying conditions (except errors)")
      on.exit(mdebug_pop())
    }

    ## Check for RngFutureCondition:s when resolving futures?
    if (isFALSE(seed)) {
      withCallingHandlers({
        resolve(fs, result = TRUE, stdout = TRUE, signal = TRUE)
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
        message <- sprintf("UNRELIABLE VALUE: One of the foreach() iterations (%s) unexpectedly generated random numbers without declaring so. There is a risk that those random numbers are not statistically sound and the overall results might be invalid. To fix this, use '%%dorng%%' from the 'doRNG' package instead of '%%dopar%%'. This ensures that proper, parallel-safe random numbers are produced. To disable this check, set option 'doFuture.rng.onMisuse' to \"ignore\".", sQuote(label))
        cond$message <- message
        if (inherits(cond, "warning")) {
          warning(cond)
          invokeRestart("muffleWarning")
        } else if (inherits(cond, "error")) {
          workarounds <- getOption("doFuture.workarounds")
          if ("BiocParallel.DoParam.errors" %in% workarounds) {
            cond$message <- sprintf('task %d failed - "%s"',
                                    kk, conditionMessage(cond))
          }
          stop(cond)
        }
      }) ## withCallingHandlers()
    } else {
      resolve(fs, result = TRUE, stdout = TRUE, signal = TRUE)
    }
  }, interrupt = function(int) {
    onInterrupt(int, op_name = "%dopar%", debug = debug)
  }, error = function(e) {
    onError(e, futures = fs, debug = debug)
  }) ## tryCatch()

  ## Gather values
  results <- local({
    if (debug) mdebug_push("Collecting values of futures ...")
    oopts <- options(future.rng.onMisuse.keepFuture = FALSE)
    on.exit({
      options(oopts)
      if (debug) mdebug_pop()
    })
    lapply(fs, FUN = value, stdout = FALSE, signal = FALSE)
  })
  rm(list = "fs")
  stop_if_not(length(results) == nchunks)

  ## Reduce chunks
  results2 <- local({
    if (debug) {
      mdebug_push("Reducing chunks ...")
      on.exit(mdebug_pop())
    }
    do.call(c, args = results)
  })


  if (length(results2) != length(args_list)) {
    chunk_sizes <- sapply(results, FUN = length)
    chunk_sizes <- table(chunk_sizes)
    chunk_summary <- sprintf("%d chunks with %s elements",
                             chunk_sizes, names(chunk_sizes))
    chunk_summary <- paste(chunk_summary, collapse = ", ")
    msg <- sprintf("Unexpected error in doFuture(): After gathering and merging the results from %d chunks into a list, the total number of elements (= %d) does not match the number of input elements in 'X' (= %d). There were in total %d chunks and %d elements (%s)", nchunks, length(results2), length(args_list), nchunks, sum(chunk_sizes), chunk_summary)
    if (debug) {
      mdebug(msg)
      mprint(chunk_sizes)
      mdebug("Results before merge chunks:")
      mstr(results)
      mdebug("Results after merge chunks:")
      mstr(results2)
    }
    msg <- sprintf("%s. Example of the first few values: %s", msg,
                   paste(capture.output(str(head(results2, 3L))),
                         collapse = "\\n"))
    ex <- FutureError(msg)
    stop(ex)
  }
  results <- results2
  rm(list = "results2")


  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## 10. Accumulate results
  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## Combine results (and identify errors)
  ## NOTE: This is adopted from foreach:::doSEQ()
  if (debug) mdebug_push("Accumulating results ...")
  tryCatch({
    if (verbose) {
      out <- capture.output({
        res <- accumulator(results, tags = seq_along(results))
      })
      void <- lapply(out, FUN = mdebug, debug = verbose)
      res
    } else {
      accumulator(results, tags = seq_along(results))
    }
  }, error = function(e) {
    cat("error calling combine function:\n")
    print(e)
    NULL
  })
  rm(list = "results")
  if (debug) mdebug_pop() ## "Accumulating results ..."

  
  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## 11. Error handling
  ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if (debug) mdebug_push("Handling errors ...")
  ## throw an error or return the combined results
  ## NOTE: This is adopted from foreach:::doSEQ()
  error_handling <- obj$errorHandling
  if (debug) {
    mdebugf("Processing errors (handler = %s)", sQuote(error_handling))
  }
  error_value <- getErrorValue(it)
  if (identical(error_handling, "stop") && !is.null(error_value)) {
    error_index <- getErrorIndex(it)
    msg <- sprintf('task %d failed - "%s"', error_index,
                   conditionMessage(error_value))
    if (debug) mdebug_pop() ## "Handling errors ..."
    stop(simpleError(msg, call = expr))
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
} ## doFuture()
})
