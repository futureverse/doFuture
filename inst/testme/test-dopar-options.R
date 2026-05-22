library(doFuture)
registerDoFuture()

plan(sequential)

message("*** %dopar% .options.multicore / .options.snow ...")

# multicore preschedule = TRUE
res <- foreach(i = 1:3, .options.multicore = list(preschedule = TRUE)) %dopar% {
  i^2
}
stopifnot(identical(res, list(1, 4, 9)))

# multicore preschedule = FALSE
res <- foreach(i = 1:3, .options.multicore = list(preschedule = FALSE)) %dopar% {
  i^2
}
stopifnot(identical(res, list(1, 4, 9)))

# snow preschedule = TRUE
res <- foreach(i = 1:3, .options.snow = list(preschedule = TRUE)) %dopar% {
  i^2
}
stopifnot(identical(res, list(1, 4, 9)))

# snow preschedule = FALSE
res <- foreach(i = 1:3, .options.snow = list(preschedule = FALSE)) %dopar% {
  i^2
}
stopifnot(identical(res, list(1, 4, 9)))

message("*** %dopar% .options.multicore / .options.snow ... DONE")


message("*** %dopar% .options.future ...")

# scheduling
res <- foreach(i = 1:3, .options.future = list(scheduling = 2.0)) %dopar% {
  i^2
}
stopifnot(identical(res, list(1, 4, 9)))

# chunk.size
res <- foreach(i = 1:3, .options.future = list(chunk.size = 2)) %dopar% {
  i^2
}
stopifnot(identical(res, list(1, 4, 9)))

message("*** %dopar% .options.future ... DONE")
