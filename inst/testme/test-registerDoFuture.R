#' @tags sequential multisession cluster multicore

library(doFuture)

strategies <- future:::supportedStrategies()

message("*** registerDoFuture() ...")

message("doSEQ() %dopar% information:")
registerDoSEQ()
message("getDoParName(): ", sQuote(getDoParName()))
message("getDoParVersion(): ", sQuote(getDoParVersion()))
message("getDoParWorkers(): ", sQuote(getDoParWorkers()))

oldDoPar <- registerDoFuture()
message("Previously registered foreach backend:")
utils::str(oldDoPar)

stopifnot(
  "fun"  %in% names(oldDoPar),
  "data" %in% names(oldDoPar),
  "info" %in% names(oldDoPar),
  is.function(oldDoPar$fun)
)

message("doFuture() %dopar% information:")

for (strategy in strategies) {
  message(sprintf("- plan('%s') ...", strategy))
  plan(strategy)

  message(name <- getDoParName())
  stopifnot(name == "doFuture")
  message(version <- getDoParVersion())
  stopifnot(packageVersion(name) == version)
  message(nbr_of_workers <- getDoParWorkers())
  stopifnot(nbr_of_workers == nbrOfWorkers())

  # Shutdown current plan
  plan(sequential)

  message(sprintf("- plan('%s') ... DONE", strategy))
} ## for (strategy ...)

message("*** registerDoFuture() ... DONE")


message("*** registerDoFuture() - option 'doRNG.rng_change_warning_skip' ...")

## registerDoFuture() tells doRNG (>= 1.8.2) to not check the RNG type
options(doRNG.rng_change_warning_skip = NULL)
registerDoFuture()
value <- getOption("doRNG.rng_change_warning_skip")
str(value)
stopifnot("doFuture" %in% value)

## Already set, i.e. nothing to do
registerDoFuture()
stopifnot(identical(getOption("doRNG.rng_change_warning_skip"), value))

## Appended to an existing character vector
options(doRNG.rng_change_warning_skip = "otherPkg")
registerDoFuture()
value <- getOption("doRNG.rng_change_warning_skip")
str(value)
stopifnot(identical(value, c("otherPkg", "doFuture")))

## Already TRUE, i.e. nothing to do
options(doRNG.rng_change_warning_skip = TRUE)
registerDoFuture()
stopifnot(isTRUE(getOption("doRNG.rng_change_warning_skip")))

## Explicitly disabled by the user, which is overridden with a warning
options(doRNG.rng_change_warning_skip = FALSE)
res <- withCallingHandlers({
  registerDoFuture()
}, warning = function(w) {
  message("Caught expected warning: ", conditionMessage(w))
  invokeRestart("muffleWarning")
})
value <- getOption("doRNG.rng_change_warning_skip")
str(value)
stopifnot(identical(value, "doFuture"))

options(doRNG.rng_change_warning_skip = NULL)

message("*** registerDoFuture() - option 'doRNG.rng_change_warning_skip' ... DONE")


message("*** registerDoFuture() - flavor ...")

registerDoFuture()
info <- foreach::getDoParRegistered()
stopifnot(isTRUE(info))
stopifnot(getDoParName() == "doFuture")

registerDoFuture("%dofuture%")
stopifnot(getDoParName() == "doFuture2")
stopifnot(packageVersion("doFuture") == getDoParVersion())
stopifnot(getDoParWorkers() == nbrOfWorkers())

## An unknown 'flavor'
res <- tryCatch(registerDoFuture("unknown"), error = identity)
stopifnot(inherits(res, "error"))
message("Caught expected error: ", conditionMessage(res))

message("*** registerDoFuture() - flavor ... DONE")


message("*** .getDoPar() ...")

.getDoPar <- doFuture:::.getDoPar

## (a) A foreach adapter is registered
registerDoFuture()
res <- .getDoPar()
str(res)
stopifnot(
  inherits(res, "DoPar"),
  is.function(res[["fun"]]),
  is.function(res[["info"]])
)

## (b) A foreach adapter without an 'info' function is registered
foreach::setDoPar(fun = res[["fun"]], data = NULL, info = NULL)
res <- .getDoPar()
str(res)
stopifnot(
  inherits(res, "DoPar"),
  is.function(res[["fun"]]),
  is.null(res[["info"]]),
  !"info" %in% names(res)
)

## Reset
registerDoFuture()
stopifnot(getDoParName() == "doFuture")

message("*** .getDoPar() ... DONE")

