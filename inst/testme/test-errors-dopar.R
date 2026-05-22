library(doFuture)
registerDoFuture()

plan(sequential)

message("*** %dopar% errors ...")

# Trigger onError during future creation
# We can do this by providing a too large global and setting a small limit
options(future.globals.maxSize = 100)
x <- rnorm(1000)

res <- tryCatch({
  foreach(i = 1:3) %dopar% {
    length(x) + i
  }
}, error = identity)

stopifnot(inherits(res, "error"))
# The error should be related to globals maxSize
message("Caught expected error: ", res$message)

options(future.globals.maxSize = NULL)

message("*** %dopar% errors ... DONE")
