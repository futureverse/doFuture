#' @tags %dopar%
#' @tags sequential

library(doFuture)
registerDoFuture()

plan(sequential)

message("*** doFuture() with doFuture.debug = TRUE ...")

options(doFuture.debug = TRUE)

message("- Custom processing order ...")

## Covers the 'ordering' code paths, both when chunks are remapped and
## when the gathered values are remapped back into their original order
n <- 5L
truth <- as.list(2 * seq_len(n))

for (ordering in list("random", rev(seq_len(n)), function(n) rev(seq_len(n)))) {
  scheduling <- structure(1.0, ordering = ordering)
  res <- foreach(i = seq_len(n),
                 .options.future = list(scheduling = scheduling)) %dopar% {
    2 * i
  }
  stopifnot(is.list(res), length(res) == n, all.equal(res, truth))

  chunk.size <- structure(2L, ordering = ordering)
  res <- foreach(i = seq_len(n),
                 .options.future = list(chunk.size = chunk.size)) %dopar% {
    2 * i
  }
  stopifnot(is.list(res), length(res) == n, all.equal(res, truth))
}

message("- Custom processing order ... DONE")


message("- Option 'conditions' ...")

## Relay only a specific class of conditions
res <- foreach(i = 1:2,
               .options.future = list(conditions = "message")) %dopar% {
  message("Hello from ", i)
  i
}
stopifnot(identical(res, list(1L, 2L)))

## Relay no conditions at all
## Note, we cannot assert that no message is relayed here, because
## doFuture.debug = TRUE makes doFuture() itself produce messages
res <- foreach(i = 1:2,
               .options.future = list(conditions = character(0))) %dopar% {
  message("Not relayed")
  i
}
stopifnot(identical(res, list(1L, 2L)))

message("- Option 'conditions' ... DONE")


message("- Rescaling option 'future.globals.maxSize' ...")

## Covers the code that scales up 'future.globals.maxSize' to account for
## the fact that more than one element is processed per future.
## Note, unlike %dofuture%, %dopar% identifies globals *before* the limit
## is rescaled, which is why the globals must fit within the original limit.
limit <- 1024^2
options(future.globals.maxSize = limit)
x <- rnorm(1000L)
stopifnot(object.size(x) < limit)

res <- foreach(i = 1:2, .options.future = list(chunk.size = 1)) %dopar% {
  ## Assert that each future sees the non-adjusted limit
  stopifnot(getOption("future.globals.maxSize") == 1024^2)
  length(x) + i
}
str(res)
stopifnot(
  length(res) == 2L,
  res[[1]] == length(x) + 1L,
  res[[2]] == length(x) + 2L
)

options(future.globals.maxSize = NULL)
rm(list = c("x", "limit"))

message("- Rescaling option 'future.globals.maxSize' ... DONE")


message("- Option 'doFuture.rng.onMisuse' ...")

## (a) Ignore that random numbers are generated
options(doFuture.rng.onMisuse = "ignore")
res <- foreach(i = 1:2) %dopar% { runif(1L) }
stopifnot(is.list(res), length(res) == 2L)

## (b) Warn when random numbers are generated
options(doFuture.rng.onMisuse = "warning")
res <- withCallingHandlers({
  foreach(i = 1:2) %dopar% { runif(1L) }
}, warning = function(w) {
  message("Caught expected warning: ", conditionMessage(w))
  invokeRestart("muffleWarning")
})
stopifnot(is.list(res), length(res) == 2L)

## (c) Give an error when random numbers are generated
options(doFuture.rng.onMisuse = "error")
res <- tryCatch({
  foreach(i = 1:2) %dopar% { runif(1L) }
}, error = identity)
stopifnot(inherits(res, "error"))
message("Caught expected error: ", conditionMessage(res))

## (d) Give an error, but reformat it the way BiocParallel's DoparParam
##     expects, cf. option 'doFuture.workarounds'
options(doFuture.rng.onMisuse = "error")
options(doFuture.workarounds = "BiocParallel.DoParam.errors")
res <- tryCatch({
  foreach(i = 1:2) %dopar% { runif(1L) }
}, error = identity)
stopifnot(
  inherits(res, "error"),
  grepl("^task [0-9]+ failed", conditionMessage(res))
)
message("Caught expected error: ", conditionMessage(res))

options(doFuture.rng.onMisuse = NULL)
options(doFuture.workarounds = NULL)

message("- Option 'doFuture.rng.onMisuse' ... DONE")


message("- Appending '.export' globals ...")

## Covers the code that appends '.export' globals that were not already
## found by the automatic lookup
res <- foreach(i = 1:2, .export = "c") %dopar% { i }
stopifnot(identical(res, list(1L, 2L)))

message("- Appending '.export' globals ... DONE")


message("- Error handling ...")

res <- tryCatch({
  foreach(i = 1:3) %dopar% {
    if (i == 2L) stop("Index error, because i = ", i)
    i
  }
}, error = identity)
stopifnot(
  inherits(res, "error"),
  grepl("task 2 failed", conditionMessage(res))
)
message("Caught expected error: ", conditionMessage(res))

message("- Error handling ... DONE")

options(doFuture.debug = FALSE)

message("*** doFuture() with doFuture.debug = TRUE ... DONE")
