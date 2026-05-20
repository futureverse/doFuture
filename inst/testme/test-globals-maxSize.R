library(doFuture)
registerDoFuture()

plan(sequential)

message("*** globals.maxSize adjustment ...")

options(doFuture.debug = TRUE)

# Set a limit
limit <- 1024^2
options(future.globals.maxSize = limit)

# Large global
n <- floor(1.1 * 1024^2 / 8)
x <- rnorm(n)
stopifnot(object.size(x) > limit)

# Case 1: %dofuture% with multiple chunks
# This should PASS because the limit is adjusted to 2MB on the main process
# during chunk processing.
res <- foreach(i = 1:2, .options.future = list(chunk.size = 1)) %dofuture% {
  length(x) + i
}
print(res)
stopifnot(length(res) == 2)
stopifnot(res[[1]] == length(x) + 1)
stopifnot(res[[2]] == length(x) + 2)

options(future.globals.maxSize = NULL)

message("*** globals.maxSize adjustment ... DONE")
