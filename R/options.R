#' Options used by the doFuture adapter 
#'
#' Below are all \R options specific to the \pkg{doFuture} package.
#' For options controlling futures in general, see
#' [the options][future::future.options] for the \pkg{future} package.\cr
#' \cr
#' _WARNING: Note that the names and the default values of
#' these options may change in future versions of the package.
#' Please use with care until further notice._
#'
#' \describe{
#'  \item{\option{doFuture.foreach.export}:}{
#'    Specifies to what extent the `.export` argument of [foreach()], paired
#'    with \code{\link[foreach:\%dopar\%]{\%dopar\%}}, should be respected or
#'    if globals should be automatically identified. This is only for
#'    `%dopar%` -- [`%dofuture%`] does not support `.export` and `.noexport`.
#' 
#'    If `".export"`, then the globals specified by the `.export`
#'    argument will be used "as is".
#' 
#'    If `".export-and-automatic"`, then globals specified by
#'    `.export` as well as those automatically identified are used.
#' 
#'    The `".export-and-automatic-with-warning"` is the same as
#'    `".export-and-automatic"`, but produces a warning if `.export`
#'    lacks some of the globals that the automatic identification locates,
#'    which could be helpful feedback to developers using [foreach()] with
#'    `%dopar%` -- also when using adapters such as **doParallel**.
#' 
#'    (Default: `".export-and-automatic"`)
#'  }
#'
#'  \item{\option{doFuture.debug}:}{If `TRUE`, extensive debug messages are
#'        generated. (Default: `FALSE`)}
#' }
#'
#' @section Environment variables that set R options:
#' All of the above \R \option{doFuture.*} options can be set by
#' corresponding environment variable \env{R_DOFUTURE_*} _when the
#' \pkg{doFuture} package is loaded_.
#' For example, if `R_DOFUTURE_DEBUG=TRUE`, then option
#' \option{doFuture.debug} is set to `TRUE` (logical).
#'
#' @keywords internal
#' @name doFuture.options
NULL
