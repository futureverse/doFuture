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


message("- reported iterations for a custom processing order ...")

## Each chunk must report the original iteration indices it processes.
truths <- list(
  list(n = 4L, chunk.size = 2L,
       ordering = c(4L, 3L, 2L, 1L),
       iterations = c("3-4", "1-2")),
  list(n = 6L, chunk.size = 3L,
       ordering = c(2L, 4L, 6L, 1L, 3L, 5L),
       iterations = c("2, 4, 6", "1, 3, 5"))
)

for (truth in truths) {
  n <- truth[["n"]]
  chunk.size <- structure(truth[["chunk.size"]], ordering = truth[["ordering"]])

  msgs <- character(0L)
  res <- withCallingHandlers({
    foreach(i = seq_len(n),
            .options.future = list(seed = FALSE, chunk.size = chunk.size)) %dofuture% {
      runif(1)
      i
    }
  }, warning = function(w) {
    msgs <<- c(msgs, conditionMessage(w))
    invokeRestart("muffleWarning")
  })

  ## Values are always returned in their original order
  stopifnot(identical(unlist(res), seq_len(n)))

  ## Map chunk index -> reported iterations
  stopifnot(length(msgs) == length(truth[["iterations"]]))
  reported <- rep(NA_character_, times = length(truth[["iterations"]]))
  for (msg in msgs) {
    idx <- as.integer(sub(".* part of chunk #([0-9]+) .*", "\\1", msg))
    stopifnot(!is.na(idx), idx >= 1L, idx <= length(reported))
    reported[idx] <- sub(".* of iterations (.*) of the foreach\\(\\) .*", "\\1", msg)
  }
  str(list(reported = reported, expected = truth[["iterations"]]))
  stopifnot(identical(reported, truth[["iterations"]]))
}

message("- reported iterations for a custom processing order ... DONE")


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
