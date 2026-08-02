library(doFuture)
registerDoFuture()

plan(sequential)

message("*** verbose = TRUE ...")

res <- foreach(i = 1:3, .verbose = TRUE) %dopar% {
  i^2
}
stopifnot(identical(res, list(1, 4, 9)))

res <- foreach(i = 1:3, .verbose = TRUE) %dofuture% {
  i^2
}
stopifnot(identical(res, list(1, 4, 9)))

message("*** verbose = TRUE ... DONE")


message("*** verbose = TRUE does not leak option 'doFuture.debug' ...")

## '.verbose = TRUE' enables option 'doFuture.debug' temporarily.  It must
## be reset when foreach() returns, otherwise all subsequent calls produce
## debug output too.  The internal debug stack must also be left as found,
## otherwise the debug output gets more and more indented for each call.
.debug <- doFuture:::.debug

for (debug0 in c(FALSE, TRUE)) {
  message(sprintf("- doFuture.debug = %s on entry ...", debug0))

  options(doFuture.debug = debug0)
  depth0 <- length(.debug[["stack"]])
  res <- foreach(i = 1:3, .verbose = TRUE) %dofuture% {
    i^2
  }
  stopifnot(identical(res, list(1, 4, 9)))
  stopifnot(identical(getOption("doFuture.debug"), debug0))
  stopifnot(length(.debug[["stack"]]) == depth0)

  options(doFuture.debug = debug0)
  depth0 <- length(.debug[["stack"]])
  res <- foreach(i = 1:3, .verbose = TRUE) %dopar% {
    i^2
  }
  stopifnot(identical(res, list(1, 4, 9)))
  stopifnot(identical(getOption("doFuture.debug"), debug0))
  stopifnot(length(.debug[["stack"]]) == depth0)

  message(sprintf("- doFuture.debug = %s on entry ... DONE", debug0))
}

options(doFuture.debug = FALSE)

message("*** verbose = TRUE does not leak option 'doFuture.debug' ... DONE")


message("*** doFuture.debug = TRUE ...")

options(doFuture.debug = TRUE)

res <- foreach(i = 1:3) %dopar% {
  i^2
}
stopifnot(identical(res, list(1, 4, 9)))

res <- foreach(i = 1:3) %dofuture% {
  i^2
}
stopifnot(identical(res, list(1, 4, 9)))

options(doFuture.debug = FALSE)

message("*** doFuture.debug = TRUE ... DONE")
