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
