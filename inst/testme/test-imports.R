library(doFuture)

import_from <- doFuture:::import_from
import_future <- doFuture:::import_future
queryRCmdCheck <- doFuture:::queryRCmdCheck
inRCmdCheck <- doFuture:::inRCmdCheck

message("*** import_from() ...")

## (a) The object exists
fcn <- import_from("nbrOfWorkers", package = "future")
str(fcn)
stopifnot(is.function(fcn), identical(fcn, future::nbrOfWorkers))

## (b) The object does not exist, but there is a default
default <- function() "default"
fcn <- import_from("no_such_function", package = "future", default = default)
str(fcn)
stopifnot(is.function(fcn), identical(fcn, default))

## (c) The object does not exist and there is no default
res <- tryCatch({
  import_from("no_such_function", package = "future")
}, error = identity)
str(res)
stopifnot(
  inherits(res, "error"),
  grepl("No such 'future' function", conditionMessage(res))
)

## (d) Non-function modes are supported too
env <- import_from(".debug", mode = "environment",
                   default = new.env(parent = emptyenv()), package = "future")
stopifnot(is.environment(env))

message("*** import_from() ... DONE")


message("*** import_future() ...")

fcn <- import_future("nbrOfWorkers")
stopifnot(is.function(fcn), identical(fcn, future::nbrOfWorkers))

fcn <- import_future("no_such_function", default = default)
stopifnot(identical(fcn, default))

message("*** import_future() ... DONE")


message("*** queryRCmdCheck() ...")

res <- queryRCmdCheck()
print(res)
stopifnot(
  is.character(res),
  length(res) == 1L,
  res %in% c("notRunning", "checkingTests", "checkingExamples")
)

evidences <- attr(res, "evidences")
str(evidences)
stopifnot(
  is.list(evidences),
  all(c("vanilla", "tests", "pwd", "examples", "win-builder") %in%
      names(evidences)),
  all(vapply(evidences, FUN = is.logical, FUN.VALUE = FALSE)),
  all(lengths(evidences) == 1L)
)

message("*** queryRCmdCheck() ... DONE")


message("*** inRCmdCheck() ...")

res <- inRCmdCheck()
print(res)
stopifnot(is.logical(res), length(res) == 1L, !is.na(res))

## The result is cached, i.e. the second call gives the same answer
res2 <- inRCmdCheck()
stopifnot(identical(res2, res))

message("*** inRCmdCheck() ... DONE")
