#' Loop over a Foreach Expression using Futures
#'
#' @param foreach A `foreach` object created by [foreach::foreach()]
#' and [foreach::times()].
#'
#' @param expr An R expression.
#'
#' @return The value of the foreach call.
#'
#' @details
#' This is a replacement for `%dopar%` of the \pkg{foreach} package
#' that leverages the \pkg{future} framework.
#'
#' When using `%dofuture%`:
#'
#' * there is no need to use `registerDoFuture()`
#'
#' * there is no need to use `%dorng%` of the **doRNG** package
#'   (but you need to specify `.options.future = list(seed = TRUE)`
#'    whenever using random numbers in the `expr` expression)
#'
#' * global variables and packages are identified automatically by
#'   the \pkg{future} framework
#'
#' * errors are relayed as-is with the default `.errorhandling = "stop"`,
#'   whereas with `%dopar%` they are captured and modified.
#'
#'
#' @section Global variables and packages:
#' When using `%dofuture%`, the future framework identifies globals and
#' packages automatically (via static code inspection).  However, there
#' are cases where it fails to find some of the globals or packages. When
#' this happens, one can specify the [future::future()] arguments `globals`
#' and `packages` via foreach argument `.options.future`.  For example,
#' if you specify argument
#' `.options.future = list(globals = structure(TRUE, ignore = "b", add = "a"))`
#' then globals are automatically identified (`TRUE`), but it ignores `b` and
#' always adds `a`.
#'
#' An alternative to specifying the `globals` and the `packages` options via
#' `.options.future`, is to use the \code{\link[future:%globals%]{%globals%}}
#' and the \code{\link[future:%packages%]{%packages%}} operators.
#' See the examples for an illustration.
#'
#' For further details and instructions, see [future::future()].
#'
#'
#' @section Random Number Generation (RNG):
#' The `%dofuture%` operator uses the future ecosystem to generate proper random
#' numbers in parallel in the same way they are generated in, for instance,
#' \pkg{future.apply}. For this to work, you need to specify
#' `.options.future = list(seed = TRUE)`.  For example,
#'
#' ```r
#' y <- foreach(i = 1:3, .options.future = list(seed = TRUE)) %dofuture% {
#'   rnorm(1)
#' }
#' ```
#'
#' Unless `seed` is `FALSE` or `NULL`, this guarantees that the exact same
#' sequence of random numbers is generated _given the same initial
#' seed / RNG state_ - this regardless of type of future backend, number of
#' workers, and scheduling ("chunking") strategy.
#' 
#' RNG reproducibility is achieved by pregenerating the random seeds for all
#' iterations by parallel RNG streams.  In each
#' iteration, these seeds are set before evaluating the foreach expression.
#' _Note, for large number of iterations this may introduce a large overhead._
#'
#' If `seed = TRUE`, then \code{\link[base:Random]{.Random.seed}}
#' is used if it holds a parallel RNG seed, otherwise one is created
#' randomly.
#'
#' If `seed = FALSE`, it is expected that none of the foreach iterations
#' use random number generation.
#' If they do, then an informative warning or error is produced depending
#' on settings. See [future::future] for more details.
#' Using `seed = NULL` is like `seed = FALSE` but without the check
#' whether random numbers were generated or not.
#'
#' As input, `seed` may also take a fixed initial seed (integer),
#' either as a full parallel RNG seed (vector of 1+6 integers), or
#' as a seed generating such a full seed. This seed will
#' be used to generate one parallel RNG stream for each iteration.
#'
#' An alternative to specifying the `seed` option via `.options.future`,
#' is to use the \code{\link[future:%seed%]{%seed%}} operator.  See
#' the examples for an illustration.
#'
#' For further details and instructions, see
#' [future.apply::future_lapply()].
#'
#'
#' @section Load balancing ("chunking"):
#' Whether load balancing ("chunking") should take place or not can be
#' controlled by specifying either argument
#' `.options.future = list(scheduling = <ratio>)` or
#' `.options.future = list(chunk.size = <count>)` to `foreach()`.
#'
#' The value `chunk.size` specifies the average number of elements
#' processed per future ("chunks").
#' If `+Inf`, then all elements are processed in a single future (one worker).
#' If `NULL`, then argument `future.scheduling` is used.
#'
#' The value `scheduling` specifies the average number of futures
#' ("chunks") that each worker processes.
#' If `0.0`, then a single future is used to process all iterations;
#' none of the other workers are used.
#' If `1.0` or `TRUE`, then one future per worker is used.
#' If `2.0`, then each worker will process two futures (if there are
#' enough iterations).
#' If `+Inf` or `FALSE`, then one future per iteration is used.
#' The default value is `scheduling = 1.0`.
#'
#' For further details and instructions, see
#' [future.apply::future_lapply()].
#'
#'
#' @section Control processing order of iterations:
#' Attribute `ordering` of `chunk.size` or `scheduling` can be used to
#' control the ordering of the elements are iterated over, which only affects
#' the processing order and _not_ the order values are returned.
#' This attribute can take the following values:
#'
#' * index vector - an numeric vector of length `nX`.
#'
#' * function     - an function taking one argument which is called as
#'                  `ordering(nX)` and which must return an
#'                  index vector of length `nX`, e.g.
#'                  `function(n) rev(seq_len(n))` for reverse ordering.
#'
#' * `"random"`   - this will randomize the ordering via random index
#'                  vector `sample.int(nX)`.
#'
#' where `nX` is the number of foreach iterations to be done.
#'
#' For example,
#' `.options.future = list(scheduling = structure(2.0, ordering = "random"))`.
#'
#' _Note_, when elements are processed out of order, then captured standard
#' output and conditions are also relayed in that order, that is, out of order.
#'
#' For further details and instructions, see
#' [future.apply::future_lapply()].
#'
#' @section Reporting on progress:
#' How to report on progress is a frequently asked question, especially
#' in long-running tasks and parallel processing.  The **foreach**
#' framework does _not_ have a built-in mechanism for progress
#' reporting(*).
#'
#' When using **doFuture**, and the Futureverse in general, for
#' processing, the **progressr** package can be used to signal progress
#' updates in a near-live fashion.  There is no special argument related to
#' `foreach()` or **doFuture** to achieve this. Instead, one calls a,
#' so called, "progressor" function within each iteration.  See
#' the [**progressr**](https://cran.r-project.org/package=progressr)
#' package and its `vignette(package = "progressr")` for examples.
#'
#' (*) The legacy **doSNOW** package uses a special `foreach()` argument
#' `.options.doSNOW$progress` that can be used to make a progress update
#' each time results from a parallel worker are returned. This approach
#' is limited by how chunking works, requires the developer to set that
#' argument, and the code becomes incompatible with foreach adaptors
#' registered by other **doNnn** packages.
#'
#'
#' @example incl/dofuture_OP.R
#'
#' @export
`%dofuture%` <- function(foreach, expr) {
  stop_if_not(inherits(foreach, "foreach"))
  expr <- substitute(expr)
  doFuture2(foreach, expr, envir = parent.frame(), data = NULL)
}
