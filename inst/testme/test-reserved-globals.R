#' @tags %dofuture%
#' @tags %dopar%
#' @tags sequential

library(doFuture)
registerDoFuture()

plan(sequential)

message("*** Reserved variable names among globals in 'args_list' ...")

## doFuture uses '...future.x_ii' internally to pass the chunk of
## iterator elements to each future.  If a global picked up from the
## iterator values uses that name, an informative error is produced.
`...future.x_ii` <- 42
fcn <- function() `...future.x_ii` + 1

message("- %dopar% ...")
res <- withCallingHandlers({
  tryCatch(foreach(f = list(fcn)) %dopar% { f() }, error = identity)
}, warning = function(w) {
  message("Caught expected warning: ", conditionMessage(w))
  invokeRestart("muffleWarning")
})
str(conditionMessage(res))
stopifnot(
  inherits(res, "error"),
  grepl("reserved variable", conditionMessage(res)),
  grepl("...future.x_ii", conditionMessage(res), fixed = TRUE)
)
message("- %dopar% ... DONE")

message("- %dofuture% ...")
res <- withCallingHandlers({
  tryCatch(foreach(f = list(fcn)) %dofuture% { f() }, error = identity)
}, warning = function(w) {
  message("Caught expected warning: ", conditionMessage(w))
  invokeRestart("muffleWarning")
})
str(conditionMessage(res))
stopifnot(
  inherits(res, "error"),
  grepl("reserved variable", conditionMessage(res)),
  grepl("...future.x_ii", conditionMessage(res), fixed = TRUE)
)
message("- %dofuture% ... DONE")

message("*** Reserved variable names among globals in 'args_list' ... DONE")
