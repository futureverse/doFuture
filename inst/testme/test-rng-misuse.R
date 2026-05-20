library(doFuture)

plan(sequential)

message("*** RNG misuse ...")

# This should trigger a warning about RNG misuse
# Note: future.rng.onMisuse defaults to "warning"
options(future.rng.onMisuse = "warning")

res <- withCallingHandlers({
  foreach(i = 1:3, .options.future = list(seed = FALSE)) %dofuture% {
    runif(1)
  }
}, warning = function(w) {
  message("Caught expected warning: ", w$message)
  invokeRestart("muffleWarning")
})

# Test with multiple iterations in a chunk to trigger seq_to_human
# We can force 1 chunk for all iterations
res <- withCallingHandlers({
  foreach(i = 1:5, .options.future = list(seed = FALSE, chunk.size = 10)) %dofuture% {
    runif(1)
  }
}, warning = function(w) {
  message("Caught expected warning: ", w$message)
  invokeRestart("muffleWarning")
})


# Test doFuture.rng.onMisuse = "ignore"
message("- doFuture.rng.onMisuse = 'ignore' ...")
options(doFuture.rng.onMisuse = "ignore")
res <- foreach(i = 1:3, .options.future = list(seed = FALSE)) %dofuture% {
  runif(1)
}
# Should not have warned

# Test doFuture.rng.onMisuse = "error"
message("- doFuture.rng.onMisuse = 'error' ...")
options(doFuture.rng.onMisuse = "error")
res <- tryCatch({
  foreach(i = 1:3, .options.future = list(seed = FALSE)) %dofuture% {
    runif(1)
  }
}, error = identity)
stopifnot(inherits(res, "error"))
message("Caught expected error: ", res$message)


message("*** RNG misuse ... DONE")
