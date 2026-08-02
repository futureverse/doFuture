#' @tags %dofuture%
#' @tags %dopar%
#' @tags multisession

library(doFuture)

options(future.debug = FALSE)

message("*** registerDoFuture(flavor = '%dofuture%') ...")

registerDoFuture(flavor = "%dofuture%")

plan(multisession, workers = 2L)

a <- 3.14
b <- 2
y_truth <- foreach(1:2, .export = c("a", "b")) %do% { b * a }
str(y_truth)


y1 <- foreach(1:2, .export = c("a", "b")) %dopar% { b * a }
str(y1)
stopifnot(identical(y1, y_truth))

y2 <- foreach(1:2) %dopar% { b * a }
str(y2)
stopifnot(identical(y2, y_truth))

y3 <- foreach(1:2, .export = NULL) %dopar% { b * a }
str(y3)
stopifnot(identical(y3, y_truth))

y4 <- foreach(1:2, .export = "a") %dopar% { b * a }
str(y4)
stopifnot(identical(y4, y_truth))

y5 <- foreach(1:2, .export = "c", .noexport = "d", .packages = "stats") %dopar% { b * a }
str(y5)
stopifnot(identical(y5, y_truth))


# Shutdown current plan
plan(sequential)

message("*** registerDoFuture(flavor = '%dofuture%') ... DONE")
