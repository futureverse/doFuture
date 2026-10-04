#' @tags %dofuture%
#' @tags %dopar%
#' @tags rng
#' @tags sequential multisession multicore

library(doFuture)

options(future.debug = FALSE, doFuture.debug = FALSE)

message("*** RNG with 'seed' via future.disposable ...")

## Random numbers must not depend on how elements are distributed
## across workers or chunks, regardless of whether 'seed' is passed
## via '.options.future' or via R option 'future.disposable'

xs <- 1:6

with_disposable_seed <- function(seed, expr, chunk.size = NULL) {
  opts <- list(seed = seed)
  if (!is.null(chunk.size)) opts$chunk.size <- chunk.size
  options(future.disposable = opts)
  on.exit(options(future.disposable = NULL))
  expr
}

## Reference results
plan(sequential)

set.seed(42)
truth_TRUE <- foreach(x = xs, .options.future = list(seed = TRUE)) %dofuture% {
  runif(1)
}
str(truth_TRUE)

truth_42 <- foreach(x = xs, .options.future = list(seed = 42L)) %dofuture% {
  runif(1)
}
str(truth_42)
stopifnot(!identical(truth_42, truth_TRUE))

## Sanity check: setting 'seed' via '.options.future' and via
## 'future.disposable' should give identical results
set.seed(42)
y <- with_disposable_seed(TRUE, foreach(x = xs) %dofuture% { runif(1) })
stopifnot(identical(y, truth_TRUE))
stopifnot(is.null(getOption("future.disposable")))

y <- with_disposable_seed(42L, foreach(x = xs) %dofuture% { runif(1) })
stopifnot(identical(y, truth_42))
stopifnot(is.null(getOption("future.disposable")))


for (cores in 1:availCores) {
  message(sprintf("Testing with %d cores ...", cores))
  options(mc.cores = cores)

  for (strategy in supportedStrategies(cores)) {
    message(sprintf("- plan('%s') ...", strategy))
    plan(strategy)

    for (chunk.size in list(NULL, 1L, 4L)) {
      message(sprintf("  - chunk.size = %s ...",
                      if (is.null(chunk.size)) "NULL" else chunk.size))

      ## %dofuture%
      set.seed(42)
      y <- with_disposable_seed(TRUE, chunk.size = chunk.size, {
        foreach(x = xs) %dofuture% { runif(1) }
      })
      stopifnot(identical(y, truth_TRUE))

      y <- with_disposable_seed(42L, chunk.size = chunk.size, {
        foreach(x = xs) %dofuture% { runif(1) }
      })
      stopifnot(identical(y, truth_42))

      ## %dopar% via registerDoFuture(flavor = "%dofuture%")
      with(registerDoFuture(flavor = "%dofuture%"), local({
        set.seed(42)
        y <- with_disposable_seed(TRUE, chunk.size = chunk.size, {
          foreach(x = xs) %dopar% { runif(1) }
        })
        stopifnot(identical(y, truth_TRUE))

        y <- with_disposable_seed(42L, chunk.size = chunk.size, {
          foreach(x = xs) %dopar% { runif(1) }
        })
        stopifnot(identical(y, truth_42))
      }))

      stopifnot(is.null(getOption("future.disposable")))
    } ## for (chunk.size ...)

    ## The %seed% operator of 'future' sets 'seed' via 'future.disposable'
    message("  - %seed% ...")
    set.seed(42)
    y <- foreach(x = xs) %dofuture% { runif(1) } %seed% TRUE
    stopifnot(identical(y, truth_TRUE))

    y <- foreach(x = xs) %dofuture% { runif(1) } %seed% 42L
    stopifnot(identical(y, truth_42))

    with(registerDoFuture(flavor = "%dofuture%"), local({
      set.seed(42)
      y <- foreach(x = xs) %dopar% { runif(1) } %seed% TRUE
      stopifnot(identical(y, truth_TRUE))

      y <- foreach(x = xs) %dopar% { runif(1) } %seed% 42L
      stopifnot(identical(y, truth_42))
    }))

    stopifnot(is.null(getOption("future.disposable")))

    plan(sequential)
    message(sprintf("- plan('%s') ... DONE", strategy))
  } ## for (strategy ...)

  message(sprintf("Testing with %d cores ... DONE", cores))
} ## for (cores ...)

message("*** RNG with 'seed' via future.disposable ... DONE")
