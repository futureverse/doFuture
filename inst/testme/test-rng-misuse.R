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
  foreach(i = 1:5, .options.future = list(seed = FALSE, chunk.size = 10L)) %dofuture% {
    runif(1)
  }
}, warning = function(w) {
  message("Caught expected warning: ", w$message)
  invokeRestart("muffleWarning")
})


# One iteration per chunk gives an "Iteration <idx>" message
msgs <- character(0L)
res <- withCallingHandlers({
  foreach(i = 1:2, .options.future = list(seed = FALSE, chunk.size = 1L)) %dofuture% {
    runif(1)
  }
}, warning = function(w) {
  msgs <<- c(msgs, conditionMessage(w))
  invokeRestart("muffleWarning")
})
stopifnot(length(msgs) == 2L, all(grepl("Iteration [0-9]+ of the foreach", msgs)))

# Elements processed in a custom order are remapped in the message
msgs <- character(0L)
scheduling <- structure(1.0, ordering = rev(seq_len(4L)))
res <- withCallingHandlers({
  foreach(i = 1:4, .options.future = list(seed = FALSE, scheduling = scheduling)) %dofuture% {
    runif(1)
  }
}, warning = function(w) {
  msgs <<- c(msgs, conditionMessage(w))
  invokeRestart("muffleWarning")
})
stopifnot(length(msgs) >= 1L, all(grepl("of the foreach", msgs)))
message("Caught expected warning: ", msgs[1])


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
