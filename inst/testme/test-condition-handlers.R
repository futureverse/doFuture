library(doFuture)

plan(sequential)

onInterrupt <- doFuture:::onInterrupt
onError <- doFuture:::onError

message("*** onInterrupt() ...")

## An interrupt is relayed as a FutureInterruptError, such that the
## next handler, i.e. onError(), can cancel all outstanding futures
for (debug in c(FALSE, TRUE)) {
  message(sprintf("- debug = %s ...", debug))
  int <- structure(
    class = c("interrupt", "condition"),
    list(message = "", call = NULL)
  )
  res <- tryCatch({
    onInterrupt(int, op_name = "%dofuture%", debug = debug)
  }, error = identity)
  str(conditionMessage(res))
  stopifnot(
    inherits(res, "error"),
    inherits(res, "FutureInterruptError"),
    grepl("%dofuture%", conditionMessage(res)),
    grepl("interrupted at", conditionMessage(res))
  )
  message(sprintf("- debug = %s ... DONE", debug))
}

message("*** onInterrupt() ... DONE")


message("*** onError() ...")

## (a) No futures to cancel
for (debug in c(FALSE, TRUE)) {
  message(sprintf("- debug = %s ...", debug))
  ex <- simpleError("boom")
  res <- withCallingHandlers({
    tryCatch(onError(ex, futures = list(), debug = debug), error = identity)
  }, warning = function(w) {
    message("Caught expected warning: ", conditionMessage(w))
    invokeRestart("muffleWarning")
  })
  str(conditionMessage(res))
  stopifnot(inherits(res, "error"), identical(conditionMessage(res), "boom"))
  message(sprintf("- debug = %s ... DONE", debug))
}

## (b) With futures that need to be canceled and resolved
fs <- lapply(1:2, FUN = function(ii) future(ii))
ex <- simpleError("boom")
res <- withCallingHandlers({
  tryCatch(onError(ex, futures = fs, debug = TRUE), error = identity)
}, warning = function(w) {
  message("Caught expected warning: ", conditionMessage(w))
  invokeRestart("muffleWarning")
})
stopifnot(inherits(res, "error"), identical(conditionMessage(res), "boom"))

## (c) The original error is relayed also when one of the futures
##     produces an error of its own
fs <- list(future(stop("Failure in future")))
ex <- simpleError("boom")
res <- withCallingHandlers({
  tryCatch(onError(ex, futures = fs, debug = FALSE), error = identity)
}, warning = function(w) {
  invokeRestart("muffleWarning")
})
stopifnot(inherits(res, "error"), identical(conditionMessage(res), "boom"))

message("*** onError() ... DONE")
