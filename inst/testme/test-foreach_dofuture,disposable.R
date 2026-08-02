library(doFuture)
registerDoFuture()

plan(sequential)

message("*** %dofuture% with future.disposable ...")

# 1. Test passing 'seed' via future.disposable
options(future.disposable = list(seed = 42L))
res1 <- foreach(i = 1:3) %dofuture% {
  runif(1)
}
stopifnot(is.null(getOption("future.disposable")))

options(future.disposable = list(seed = 42L))
res2 <- foreach(i = 1:3) %dofuture% {
  runif(1)
}
stopifnot(identical(res1, res2))


# 2. Test passing 'globals' via future.disposable
# Use character vector for now, see notes about list-based globals
x <- 10
options(future.disposable = list(globals = "x"))
res <- foreach(i = 1:1) %dofuture% {
  x + i
}
stopifnot(res[[1]] == 11)
stopifnot(is.null(getOption("future.disposable")))


# 3. Test passing 'packages' via future.disposable
options(future.disposable = list(packages = "utils"))
res <- foreach(i = 1:1) %dofuture% {
  packageVersion("utils")
}
stopifnot(is.null(getOption("future.disposable")))


# 4. Test with dispose = FALSE attribute
options(future.disposable = structure(list(seed = 42L), dispose = FALSE))
res <- foreach(i = 1:1) %dofuture% {
  runif(1)
}
stopifnot(!is.null(getOption("future.disposable")))
options(future.disposable = NULL)

# 5. Test that later options in future.disposable overwrite earlier ones
options(future.disposable = list(seed = 42L))
options(future.disposable = list(seed = 43L)) # Overwrites
res <- foreach(i = 1:1) %dofuture% {
  runif(1)
}
# This test doesn't easily verify the value without more complexity, 
# but ensures the mechanism works without error.

# 6. Test multiple options at once
x <- 10
options(future.disposable = list(seed = 42L, globals = "x", packages = "utils"))
res <- foreach(i = 1:1) %dofuture% {
  x + i + runif(1)
}
stopifnot(is.null(getOption("future.disposable")))


# 7. Test with dispose = TRUE attribute (explicit)
options(future.disposable = structure(list(seed = 42L), dispose = TRUE))
res <- foreach(i = 1:1) %dofuture% {
  runif(1)
}
stopifnot(is.null(getOption("future.disposable")))


# 8. Test with non-logical dispose attribute (should still dispose)
options(future.disposable = structure(list(seed = 42L), dispose = "yes"))
res <- foreach(i = 1:1) %dofuture% {
  runif(1)
}
stopifnot(is.null(getOption("future.disposable")))


message("*** %dofuture% with future.disposable ... DONE")
