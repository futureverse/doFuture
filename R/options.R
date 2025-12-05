#' _WARNING: Note .export and .noexport are DEFUNCT
#' foreach() does not support argument '.export' and '.noexport' when using %dofuture%. 
#' Use .options.future = list(globals = structure(..., add = ..., remove= ...)) instead")
#' _

#' Options used by the doFuture adapter 
#'
#' Below are all \R options specific to the \pkg{doFuture} package.
#' For options controlling futures in general, see
#' [the options][future::future.options] for the \pkg{future} package.\cr
#' \cr
#'
#' \describe{
#'  \item{\option{doFuture.foreach.export}:}{
#'    Specifies to what extent the \code{.export} argument of
#'    \code{\link[foreach]{foreach}()} should be respected or if globals
#'    should be automatically identified.
#' 
#'    If \code{".export"}, then the globals specified by the \code{.export}
#'    argument will be used "as is".
#' 
#'    If \code{".export-and-automatic"}, then globals specified by
#'    \code{.export} as well as those automatically identified are used.
#' 
#'    The \code{".export-and-automatic-with-warning"} is the same as
#'    \code{".export-and-automatic"}, but produces a warning if \code{.export}
#'    lacks some of the globals that the automatic identification locates
#'    - this is helpful feedback to developers using \code{foreach()}.
#' 
#'    (Default: \code{".export-and-automatic"})
#'  }
#'
#'  \item{\option{doFuture.debug}:}{If `TRUE`, extensive debug messages are
#'        generated. (Default: `FALSE`)}
#' }
#'
#' @section Environment variables that set R options:
#' All of the above \R \option{doFfuture.*} options can be set by
#' corresponding environment variable \env{R_FOFUTURE_*} _when the
#' \pkg{doFuture} package is loaded_.
#' For example, if `R_DOFUTURE_DEBUG=TRUE`, then option
#' \option{doFuture.debug} is set to `TRUE` (logical).
#'
#' @keywords internal
#' @name doFuture.options
NULL
