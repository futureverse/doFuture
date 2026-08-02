#' @tags %dofuture%
#' @tags %dopar%
#' @tags sequential

library(doFuture)
registerDoFuture()

plan(sequential)

message("*** Future labels ...")

message("- %dofuture% ...")

## Default labels
res <- foreach(i = 1:2) %dofuture% { i }
stopifnot(identical(res, list(1L, 2L)))

## Custom labels
res <- foreach(i = 1:2,
               .options.future = list(label = "my-label-%d")) %dofuture% {
  i
}
stopifnot(identical(res, list(1L, 2L)))

## WORKAROUND for futurize (<= 0.3.0), which passes a label that is not
## a valid sprintf() format
res <- foreach(i = 1:2,
               .options.future = list(label = "fz:foreach::%:%-%d")) %dofuture% {
  i
}
stopifnot(identical(res, list(1L, 2L)))

## Exceptions
res <- tryCatch({
  foreach(i = 1:2, .options.future = list(label = c("a", "b"))) %dofuture% { i }
}, error = identity)
stopifnot(inherits(res, "error"))
message("Caught expected error: ", conditionMessage(res))

res <- tryCatch({
  foreach(i = 1:2, .options.future = list(label = 42L)) %dofuture% { i }
}, error = identity)
stopifnot(inherits(res, "error"))
message("Caught expected error: ", conditionMessage(res))

message("- %dofuture% ... DONE")


message("- %dopar% ...")

res <- foreach(i = 1:2,
               .options.future = list(label = "my-label-%d")) %dopar% { i }
stopifnot(identical(res, list(1L, 2L)))

res <- tryCatch({
  foreach(i = 1:2, .options.future = list(label = c("a", "b"))) %dopar% { i }
}, error = identity)
stopifnot(inherits(res, "error"))
message("Caught expected error: ", conditionMessage(res))

res <- tryCatch({
  foreach(i = 1:2, .options.future = list(label = 42L)) %dopar% { i }
}, error = identity)
stopifnot(inherits(res, "error"))
message("Caught expected error: ", conditionMessage(res))

message("- %dopar% ... DONE")

message("*** Future labels ... DONE")
