library(doFuture)
registerDoFuture()

plan(sequential)

message("*** %dopar% with future.disposable ...")

# 1. Test passing 'globals' via future.disposable
x <- 10
options(future.disposable = list(globals = "x"))
res <- foreach(i = 1:1) %dopar% {
  x + i
}
stopifnot(res[[1]] == 11)
stopifnot(is.null(getOption("future.disposable")))


# 2. Test passing 'packages' via future.disposable
options(future.disposable = list(packages = "utils"))
res <- foreach(i = 1:1) %dopar% {
  packageVersion("utils")
}
stopifnot(is.null(getOption("future.disposable")))


# 3. Test with dispose = FALSE attribute
options(future.disposable = structure(list(globals = "x"), dispose = FALSE))
res <- foreach(i = 1:1) %dopar% {
  x + i
}
stopifnot(!is.null(getOption("future.disposable")))
options(future.disposable = NULL)


# 4. Test multiple options at once
x <- 10
options(future.disposable = list(globals = "x", packages = "utils"))
res <- foreach(i = 1:1) %dopar% {
  x + i
}
stopifnot(is.null(getOption("future.disposable")))


message("*** %dopar% with future.disposable ... DONE")
