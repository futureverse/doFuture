library(doFuture)
registerDoFuture()

plan(sequential)

message("*** debug = TRUE ...")

options(doFuture.debug = TRUE)

# doFuture2 (%dofuture%)
res <- foreach(i = 1:3) %dofuture% {
  i^2
}
stopifnot(identical(res, list(1, 4, 9)))

# doFuture (%dopar%)
res <- foreach(i = 1:3) %dopar% {
  i^2
}
stopifnot(identical(res, list(1, 4, 9)))

# With .verbose = TRUE
res <- foreach(i = 1:3, .verbose = TRUE) %dofuture% {
  i^2
}
stopifnot(identical(res, list(1, 4, 9)))

res <- foreach(i = 1:3, .verbose = TRUE) %dopar% {
  i^2
}
stopifnot(identical(res, list(1, 4, 9)))

# With .options.future = list(debug = TRUE) (extra option)
res <- foreach(i = 1:3, .options.future = list(debug = TRUE)) %dofuture% {
  i^2
}
stopifnot(identical(res, list(1, 4, 9)))

res <- foreach(i = 1:3, .options.future = list(debug = TRUE)) %dopar% {
  i^2
}
stopifnot(identical(res, list(1, 4, 9)))

# Trigger error paths with debug = TRUE
# RNG misuse as error
options(future.rng.onMisuse = "error")
res <- tryCatch({
  foreach(i = 1:3, .options.future = list(seed = FALSE)) %dofuture% {
    runif(1)
  }
}, error = identity)
stopifnot(inherits(res, "error"))

# RNG misuse as error in %dopar%
res <- tryCatch({
  foreach(i = 1:3, .options.future = list(seed = FALSE)) %dopar% {
    runif(1)
  }
}, error = identity)
stopifnot(inherits(res, "error"))

options(doFuture.debug = FALSE)
options(future.rng.onMisuse = "warning")

message("*** debug = TRUE ... DONE")
