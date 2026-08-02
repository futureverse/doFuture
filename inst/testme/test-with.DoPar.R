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

message("*** with() for 'DoPar' return value ...")

## A visible value is returned visibly
res <- with(registerDoFuture(), { 6 * 7 })
stopifnot(identical(res, 42))
stopifnot(foreach::getDoParName() == "doSEQ")

## An invisible value is returned invisibly
res <- withVisible(with(registerDoFuture(), invisible(6 * 7)))
str(res)
stopifnot(identical(res[["value"]], 42), isFALSE(res[["visible"]]))
stopifnot(foreach::getDoParName() == "doSEQ")

message("*** with() for 'DoPar' return value ... DONE")


message("*** with() for 'DoPar' with both 'expr' and local = TRUE ...")

res <- tryCatch({
  local({
    with(registerDoFuture(), { 42 }, local = TRUE)
  })
}, error = identity)
stopifnot(
  inherits(res, "error"),
  grepl("must not be specified when local = TRUE", conditionMessage(res))
)
message("Caught expected error: ", conditionMessage(res))

## Note, registerDoFuture() was called before the error was produced,
## so the doFuture adapter is still registered here
stopifnot(foreach::getDoParName() == "doFuture")
foreach::registerDoSEQ()
stopifnot(foreach::getDoParName() == "doSEQ")

message("*** with() for 'DoPar' with both 'expr' and local = TRUE ... DONE")


message("*** with() for 'DoPar' without 'expr' ...")

# local = FALSE and 'expr' is missing (should error or fail to eval)
# with.DoPar(registerDoFuture())
res <- tryCatch({
  with(registerDoFuture())
}, error = identity)
stopifnot(inherits(res, "error"))
message("Caught expected error when 'expr' is missing: ", res$message)

message("*** with() for 'DoPar' without 'expr' ... DONE")
