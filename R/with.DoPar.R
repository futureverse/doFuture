#' Evaluate an Expression using a Temporarily Registered Foreach `%dopar%` Adapter
#'
#' @param data The foreach `%dopar% adapter to use temporarily.
#'
#' @param expr The R expression to be evaluated.
#'
#' @param \ldots Not used.
#'
#' @param local If TRUE, then the future plan specified by `data`
#' is applied temporarily in the calling frame. Argument `expr` must
#' not be specified if `local = TRUE`.
#'
#' @param envir The environment where the adapter should be set and the
#' expression evaluated.
#'
#' @param \ldots Not used.
#'
#' @returns
#' The value of `expr` if `local = FALSE`, otherwise NULL invisibly.
#'
#' @example incl/with.R
#'
#' @importFrom foreach setDoPar
#' @export
with.DoPar <- function(data, expr, ..., local = FALSE, envir = parent.frame()) {
  ## The registerDoFuture() function has already been called when we get here
  ## It won't work with doParallel::registerDoParallel(), because it does not
  ## return the previous adapter. Only registerDoFuture() does that.
  oldDoPar <- data
  

  undoDoPar <- function() {
    do.call(setDoPar, args = oldDoPar)
  }

  if (local) {
    if (!missing(expr)) stop("Argument 'expr' must not be specified when local = TRUE")
    call <- as.call(list(undoDoPar))
    args <- list(call, add = TRUE, after = TRUE)
    do.call(base::on.exit, args = args, envir = envir)
    invisible(NULL)
  } else {
    on.exit(undoDoPar())
    res <- withVisible(eval(expr, envir = envir, enclos = baseenv()))
    if (res[["visible"]]) res[["value"]] else invisible(res[["value"]])
  }
}
