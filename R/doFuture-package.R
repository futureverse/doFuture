#' doFuture: Foreach Parallel Adapter using Futures
#'
#' The \pkg{doFuture} package provides mechanisms for using the
#' \pkg{foreach} package together with the \pkg{future} package
#' such that `foreach()` parallelizes via *any* future backend.
#' There are three alternative ways to use this package:
#'   1. `y <- foreach(...) %do% { ... } |> futurize()`
#'   2. `y <- foreach(...) %dofuture% { ... }`
#'   3. `y <- foreach(...) %dopar% { ... }` with `registerDoFuture()`
#'
#' @section foreach() with %do% and futurize() (recommended):
#' The _first alternative_ (recommended) uses `futurize()` of the
#' \href{https://cran.r-project.org/package=futurize}{\pkg{futurize}} package.
#' An example is:
#'
#' ```r
#' library(futurize)
#' plan(multisession)
#'
#' y <- foreach(x = 1:4, y = 1:10) %do% {
#'   z <- x + y
#'   slow_sqrt(z)
#' } |> futurize()
#' ```
#'
#' This alternative is the recommended and most clean way to let `foreach()`
#' parallelize via the future framework if you start out from scratch.
#' All you need to remember is to pipe it to `futurize()`, and, yes, it is
#' correct to use `%do%` here.
#' In addition to `multisession`, parallelization can be done via any of
#' the compliant \href{https://www.futureverse.org/backends.html}{future backends}.
#' Identification of globals, random number generation (RNG), and error
#' handling is handled the same way as elsewhere in the future ecosystem.
#' We recommend to use `futurize()`, because it is consistent with how we
#' parallelize `lapply()` and `purrr::map()` using **futurize**.
#' With `futurize()`, you do not have to explicitly load **doFuture** -
#' instead **doFuture** will serve `futurize()` under the hood.
#'
#' @section foreach() with %dofuture%:
#' The _second alternative_ (formerly recommended), which uses
#' [`%dofuture%`], is what `futurize()` does automatically under the hood,
#' and they are effectively the same.
#' An example is:
#'
#' ```r
#' library(doFuture)
#' plan(multisession)
#'
#' y <- foreach(x = 1:4, y = 1:10) %dofuture% {
#'   z <- x + y
#'   slow_sqrt(z)
#' }
#' ```
#'
#' This alternative is the formerly recommended way to let `foreach()`
#' parallelize via the future framework if you start out from scratch,
#' but we now recommend `futurize()` because it keeps the code neater.
#' See [`%dofuture%`] for more details and examples on this approach.
#'
#' @section foreach() with %dopar% and registerDoFuture():
#' The _third alternative_ is based on the traditional **foreach**
#' approach where one registers a foreach adapter to be used by `%dopar%`.
#' Contrary to above two approaches, you must not forget to register a
#' foreach adapter in order parallelize. This package provides
#' `registerDoFuture()`, which causes `%dopar% to parallelize via the
#' future framework.
#' An example is:
#'
#' ```r
#' library(doFuture)
#' registerDoFuture()
#' plan(multisession)
#'
#' y <- foreach(x = 1:4, y = 1:10) %dopar% {
#'   z <- x + y
#'   slow_sqrt(z)
#' }
#' ```
#'
#' This alternative is useful if you already have a lot of R code that
#' uses `%dopar%` and you just want to switch to using the future
#' framework for parallelization.  Using `registerDoFuture()` is also
#' useful when you wish to use the future framework with packages and
#' functions that use `foreach()` and `%dopar%` internally, but does not
#' yet support the `futurize()` approach, e.g. **[NMF]**.
#' See [registerDoFuture()] for more details and examples on this approach.
#'
#'
#' [future.apply]: https://cran.r-project.org/package=future.apply
#' [futurize]: https://cran.r-project.org/package=futurize
#' [furrr]: https://cran.r-project.org/package=furrr
#' [NMF]: https://cran.r-project.org/package=NMF
#'
#' @aliases doFuture-package
#' @name doFuture
"_PACKAGE"
