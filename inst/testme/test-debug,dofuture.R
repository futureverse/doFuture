#' @tags %dofuture%
#' @tags sequential

library(doFuture)

plan(sequential)

message("*** doFuture2() with doFuture.debug = TRUE ...")

options(doFuture.debug = TRUE)

message("- Custom processing order ...")

n <- 5L
truth <- as.list(2 * seq_len(n))

for (ordering in list("random", rev(seq_len(n)), function(n) rev(seq_len(n)))) {
  scheduling <- structure(1.0, ordering = ordering)
  res <- foreach(i = seq_len(n),
                 .options.future = list(scheduling = scheduling)) %dofuture% {
    2 * i
  }
  stopifnot(is.list(res), length(res) == n, all.equal(res, truth))

  chunk.size <- structure(2L, ordering = ordering)
  res <- foreach(i = seq_len(n),
                 .options.future = list(chunk.size = chunk.size)) %dofuture% {
    2 * i
  }
  stopifnot(is.list(res), length(res) == n, all.equal(res, truth))
}

message("- Custom processing order ... DONE")


message("- Parallel RNG ...")

## Covers the code paths that generate, report, and assign RNG seeds
res1 <- foreach(i = 1:3, .options.future = list(seed = TRUE)) %dofuture% {
  runif(1L)
}
str(res1)
stopifnot(is.list(res1), length(res1) == 3L)

## The same seed gives the same random numbers
res2 <- foreach(i = 1:3, .options.future = list(seed = 42L)) %dofuture% {
  runif(1L)
}
res3 <- foreach(i = 1:3, .options.future = list(seed = 42L)) %dofuture% {
  runif(1L)
}
stopifnot(identical(res2, res3))

message("- Parallel RNG ... DONE")


message("- Rescaling option 'future.globals.maxSize' ...")

limit <- 1024^2
options(future.globals.maxSize = limit)
x <- rnorm(1000L)

res <- foreach(i = 1:2, .options.future = list(chunk.size = 1)) %dofuture% {
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


message("- foreach-style error handling ...")

## Covers the code path where the foreach expression is wrapped in a
## tryCatch(), i.e. .options.future = list(errors = "foreach")
.options.future <- list(errors = "foreach")

res <- tryCatch({
  foreach(i = 1:3, .errorhandling = "stop",
          .options.future = .options.future) %dofuture% {
    if (i == 2L) stop("Index error, because i = ", i)
    i
  }
}, error = identity)
stopifnot(
  inherits(res, "error"),
  grepl("task 2 failed", conditionMessage(res))
)
message("Caught expected error: ", conditionMessage(res))

res <- foreach(i = 1:3, .errorhandling = "remove",
               .options.future = .options.future) %dofuture% {
  if (i == 2L) stop("Index error, because i = ", i)
  i
}
str(res)
stopifnot(is.list(res), length(res) == 2L)

message("- foreach-style error handling ... DONE")


message("- Invalid '.combine' function ...")

boom <- function(...) stop("boom!")
res <- tryCatch({
  foreach(i = 1:3, .combine = boom) %dofuture% { i }
}, error = identity)
stopifnot(inherits(res, "error"), inherits(res, "FutureError"))
message("Caught expected error: ", conditionMessage(res))

message("- Invalid '.combine' function ... DONE")

options(doFuture.debug = FALSE)

message("*** doFuture2() with doFuture.debug = TRUE ... DONE")


message("*** doFuture.globals.scanVanillaExpression = FALSE ...")

## By default, the %dofuture% expression is scanned for globals also
## on its own, in order to pick up cases such as 'a <- a + 1'
a <- 2
res <- foreach(i = 1:2) %dofuture% { a * i }
stopifnot(identical(res, list(2, 4)))

options(doFuture.globals.scanVanillaExpression = FALSE)
res <- foreach(i = 1:2) %dofuture% { a * i }
stopifnot(identical(res, list(2, 4)))
options(doFuture.globals.scanVanillaExpression = TRUE)

message("*** doFuture.globals.scanVanillaExpression = FALSE ... DONE")
