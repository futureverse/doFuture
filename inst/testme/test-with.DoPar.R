#' @tags with
#' @tags %dopar%
#' @tags sequential multisession

library(doFuture)

foreach::registerDoSEQ()
stopifnot(foreach::getDoParName() == "doSEQ")

with(registerDoFuture(), {
  stopifnot(foreach::getDoParName() == "doFuture")
})
stopifnot(foreach::getDoParName() == "doSEQ")

with(registerDoFuture("%dopar%"), {
  stopifnot(foreach::getDoParName() == "doFuture")
})
stopifnot(foreach::getDoParName() == "doSEQ")

with(registerDoFuture("%dofuture%"), {
  stopifnot(foreach::getDoParName() == "doFuture2")
})
stopifnot(foreach::getDoParName() == "doSEQ")


local({
  with(registerDoFuture(), local = TRUE)
  stopifnot(foreach::getDoParName() == "doFuture")
})
stopifnot(foreach::getDoParName() == "doSEQ")

local({
  with(registerDoFuture("%dopar%"), local = TRUE)
  stopifnot(foreach::getDoParName() == "doFuture")
})
stopifnot(foreach::getDoParName() == "doSEQ")

local({
  with(registerDoFuture("%dofuture%"), local = TRUE)
  stopifnot(foreach::getDoParName() == "doFuture2")
})
stopifnot(foreach::getDoParName() == "doSEQ")

message("*** with.DoPar() without 'expr' ...")

# local = FALSE and 'expr' is missing (should error or fail to eval)
# with.DoPar(registerDoFuture())
res <- tryCatch({
  with(registerDoFuture())
}, error = identity)
stopifnot(inherits(res, "error"))
message("Caught expected error when 'expr' is missing: ", res$message)

message("*** with.DoPar() without 'expr' ... DONE")
