#' @tags %dopar%
#' @tags sequential multisession

library(doFuture)

strategies <- future:::supportedStrategies()

message("*** doFuture w/ %dopar% - ordering ...")

registerDoFuture()

n <- 5L

orderings <- list(
  "random",
  seq_len(n),
  rev(seq_len(n)),
  function(n) rev(seq_len(n))
)

truth <- as.list(2 * seq_len(n))

for (strategy in strategies) {
  message(sprintf("- plan('%s') ...", strategy))
  plan(strategy)

  for (oi in seq_along(orderings)) {
    ordering <- orderings[[oi]]
    label <- if (is.function(ordering)) {
      "function"
    } else if (is.character(ordering)) {
      ordering
    } else {
      paste(ordering, collapse = ",")
    }

    ## -- future.scheduling with ordering --
    message(sprintf("  - future.scheduling w/ ordering = %s ...", label))
    scheduling <- structure(1.0, ordering = ordering)
    res <- foreach(i = seq_len(n),
                   .options.future = list(scheduling = scheduling)) %dopar% {
      2 * i
    }
    stopifnot(
      is.list(res),
      length(res) == n,
      all.equal(res, truth)
    )
    message(sprintf("  - future.scheduling w/ ordering = %s ... DONE", label))

    ## -- future.chunk.size with ordering --
    message(sprintf("  - future.chunk.size w/ ordering = %s ...", label))
    chunk.size <- structure(2L, ordering = ordering)
    res <- foreach(i = seq_len(n),
                   .options.future = list(chunk.size = chunk.size)) %dopar% {
      2 * i
    }
    stopifnot(
      is.list(res),
      length(res) == n,
      all.equal(res, truth)
    )
    message(sprintf("  - future.chunk.size w/ ordering = %s ... DONE", label))
  } ## for (oi ...)

  ## Shutdown current plan
  plan(sequential)

  message(sprintf("- plan('%s') ... DONE", strategy))
} ## for (strategy ...)

message("*** doFuture w/ %dopar% - ordering ... DONE")
