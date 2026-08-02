#' @tags %dofuture%
#' @tags detritus-files
#' @tags sequential multisession cluster multicore

library(doFuture)
options(
#  parallelly.debug = TRUE,
#  future.debug = TRUE,
#  doFuture.debug = TRUE
)

strategies <- future:::supportedStrategies()

message("*** doFuture - explicitly exported globals ...")

message("- Globals manually specified as named list - also with '...' ...")

x <- 1:3
y_truth <- lapply(1:2, FUN = function(i) x[c(i, 2:3)])
str(y_truth)
  
for (strategy in strategies) {
  message(sprintf("- plan('%s') ...", strategy))
  plan(strategy)

  ## (a) automatic
  sub <- function(x, ...) {
    foreach(i = 1:2) %dofuture% { x[c(i, ...)] }
  }
  y <- sub(x, 2:3)
  str(y)
  stopifnot(identical(y, y_truth))

  ## (b) explicit and with '...'
  sub <- function(x, ...) {
    foreach(i = 1:2, .options.future = list(globals = c("x", "..."))) %dofuture% { x[c(i, ...)] }
  }
  y <- sub(x, 2:3)
  str(y)
  stopifnot(identical(y, y_truth))

  ## (c) with '...', but not last
  sub <- function(x, ...) {
    foreach(i = 1:2, .options.future = list(globals = c("...", "x"))) %dofuture% { x[c(i, ...)] }
  }
  y <- sub(x, 2:3)
  str(y)
  stopifnot(identical(y, y_truth))
  
  ## (d) explicit, but forgotten '...'
  sub <- function(x, ...) {
    foreach(i = 1:2, .options.future = list(globals = c("x"))) %dofuture% { x[c(i, ...)] }
  }
  y <- tryCatch(sub(x, 2:3), error = identity)
  str(y)
  stopifnot(inherits(y, "simpleError"))

  # Shutdown current plan
  plan(sequential)

  message(sprintf("- plan('%s') ... DONE", strategy))
} ## for (strategy ...)

message("*** doFuture - explicitly exported globals ... DONE")


message("*** doFuture - automatically finding globals ...")

## Example adopted from StackOverflow comment
## https://stackoverflow.com/a/10114192/1072091
fibonacci <- function(n) {
  if (n <= 1L) return(1L)
  return(fibonacci(n - 1L) + fibonacci(n - 2L))
}
X <- matrix(1:4, nrow = 3L, ncol = 4L)
y_truth <- foreach(rr = 1:nrow(X)) %do% {
  Vectorize(fibonacci)(X[rr, ])
}
str(y_truth)

res0 <- NULL

for (strategy in strategies) {
  message(sprintf("- plan('%s') ...", strategy))
  plan(strategy)

  y <- foreach(rr = 1:nrow(X)) %dofuture% {
    Vectorize(fibonacci)(X[rr, ])
  }
  str(y)
  stopifnot(all.equal(y, y_truth))

  # Shutdown current plan
  plan(sequential)

  message(sprintf("- plan('%s') ... DONE", strategy))
} ## for (strategy ...)


message("*** doFuture - automatically finding globals ... DONE")


message("*** doFuture - automatically finding globals in 'args_list' ...")

library("tools") ## toTitleCase()

a <- 42
b <- 21
F <- list(
  function() b / 2,
  function(b) 2 * a,
  function() a + b
)
G <- list(
  function(b) 2 * a,
  function() b / 2,
  function() nchar(toTitleCase("hello world"))
)
z0 <- foreach(f = F, g = G) %do% list(f(), g())
str(z0)

for (strategy in strategies) {
  message(sprintf("- plan('%s') ...", strategy))
  plan(strategy)
  
  message("- foreach(f = X, ...) - 'f' containing globals ...")
  ## From https://github.com/futureverse/future.apply/issues/12
  z1 <- foreach(f = F, g = G) %dofuture% list(f(), g())
  str(z1)
  stopifnot(identical(z1, z0))

  message("- foreach() - globals are picked up ...")
  y <- foreach(x = 0) %dofuture% {
    message(sprintf("Globals: a = %s, b = %s", a, b))
    y ~ a + b
  }
  stopifnot(is.list(y), length(y) == 1L, inherits(y[[1]], "formula"))

  message("- foreach() - .export and .noexport must not be used ...")
  y <- tryCatch({
    foreach(x = 0, .export = c("a", "b")) %dofuture% {
      message(sprintf("Globals: a = %s, b = %s", a, b))
      y ~ a + b
    }
  }, error = identity)
  stopifnot(inherits(y, "error"))
  
  y <- tryCatch({
    foreach(x = 0, .noexport = c("a", "b")) %dofuture% {
      message(sprintf("Globals: a = %s, b = %s", a, b))
      y ~ a + b
    }
  }, error = identity)
  stopifnot(inherits(y, "error"))

  message("- foreach() - globals can be added ...")
  y <- tryCatch({
    foreach(x = 0, .options.future = list(globals = structure(TRUE, add = c("a", "b")))) %dofuture% {
      message(sprintf("Globals: a = %s, b = %s", get("a"), get("b")))
      y ~ 42
    }
  }, error = identity)
  stopifnot(is.list(y), length(y) == 1L, inherits(y[[1]], "formula"))

  message("- foreach() - globals can be ignored ...")
  y <- tryCatch({
    foreach(x = 0, .options.future = list(globals = structure(TRUE, ignore = c("a", "b")))) %dofuture% {
      message(sprintf("Globals: a = %s, b = %s", a, b))
      y ~ a + b
    }
  }, error = identity)
  stopifnot(
    inherits(y, "error") || inherits(plan("next"), c("sequential", "multicore"))
  )

  # Shutdown current plan
  plan(sequential)
} ## for (strategy ...)


message("*** doFuture - automatically finding globals in 'args_list' ... DONE")
