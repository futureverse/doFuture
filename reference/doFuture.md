# doFuture: Foreach Parallel Adapter using Futures

The doFuture package provides mechanisms for using the foreach package
together with the future package such that
[`foreach()`](https://rdrr.io/pkg/foreach/man/foreach.html) parallelizes
via *any* future backend. There are three alternative ways to use this
package:

1.  `y <- foreach(...) %do% { ... } |> futurize()`

2.  `y <- foreach(...) %dofuture% { ... }`

3.  `y <- foreach(...) %dopar% { ... }` with
    [`registerDoFuture()`](https://doFuture.futureverse.org/reference/registerDoFuture.md)

## foreach() with %do% and futurize() (recommended)

The *first alternative* (recommended) uses
[`futurize()`](https://futurize.futureverse.org/reference/futurize.html)
of the [futurize](https://cran.r-project.org/package=futurize) package.
An example is:

    library(futurize)
    plan(multisession)

    y <- foreach(x = 1:4, y = 1:10) %do% {
      z <- x + y
      slow_sqrt(z)
    } |> futurize()

This alternative is the recommended and most clean way to let
[`foreach()`](https://rdrr.io/pkg/foreach/man/foreach.html) parallelize
via the future framework if you start out from scratch. All you need to
remember is to pipe it to
[`futurize()`](https://futurize.futureverse.org/reference/futurize.html),
and, yes, it is correct to use `%do%` here. In addition to
`multisession`, parallelization can be done via any of the compliant
[future backends](https://www.futureverse.org/backends.html).
Identification of globals, random number generation (RNG), and error
handling is handled the same way as elsewhere in the future ecosystem.
We recommend to use
[`futurize()`](https://futurize.futureverse.org/reference/futurize.html),
because it is consistent with how we parallelize
[`lapply()`](https://rdrr.io/r/base/lapply.html) and
[`purrr::map()`](https://purrr.tidyverse.org/reference/map.html) using
**futurize**. With
[`futurize()`](https://futurize.futureverse.org/reference/futurize.html),
you do not have to explicitly load **doFuture** - instead **doFuture**
will serve
[`futurize()`](https://futurize.futureverse.org/reference/futurize.html)
under the hood.

## foreach() with %dofuture%

The *second alternative* (formerly recommended), which uses
[`%dofuture%`](https://doFuture.futureverse.org/reference/grapes-dofuture-grapes.md),
is what
[`futurize()`](https://futurize.futureverse.org/reference/futurize.html)
does automatically under the hood, and they are effectively the same. An
example is:

    library(doFuture)
    plan(multisession)

    y <- foreach(x = 1:4, y = 1:10) %dofuture% {
      z <- x + y
      slow_sqrt(z)
    }

This alternative is the formerly recommended way to let
[`foreach()`](https://rdrr.io/pkg/foreach/man/foreach.html) parallelize
via the future framework if you start out from scratch, but we now
recommend
[`futurize()`](https://futurize.futureverse.org/reference/futurize.html)
because it keeps the code neater. See
[`%dofuture%`](https://doFuture.futureverse.org/reference/grapes-dofuture-grapes.md)
for more details and examples on this approach.

## foreach() with %dopar% and registerDoFuture()

The *third alternative* is based on the traditional **foreach** approach
where one registers a foreach adapter to be used by `%dopar%`. Contrary
to above two approaches, you must not forget to register a foreach
adapter in order parallelize. This package provides
[`registerDoFuture()`](https://doFuture.futureverse.org/reference/registerDoFuture.md),
which causes \`%dopar% to parallelize via the future framework. An
example is:

    library(doFuture)
    registerDoFuture()
    plan(multisession)

    y <- foreach(x = 1:4, y = 1:10) %dopar% {
      z <- x + y
      slow_sqrt(z)
    }

This alternative is useful if you already have a lot of R code that uses
`%dopar%` and you just want to switch to using the future framework for
parallelization. Using
[`registerDoFuture()`](https://doFuture.futureverse.org/reference/registerDoFuture.md)
is also useful when you wish to use the future framework with packages
and functions that use
[`foreach()`](https://rdrr.io/pkg/foreach/man/foreach.html) and
`%dopar%` internally, but does not yet support the
[`futurize()`](https://futurize.futureverse.org/reference/futurize.html)
approach, e.g. **[NMF](https://cran.r-project.org/package=NMF)**. See
[`registerDoFuture()`](https://doFuture.futureverse.org/reference/registerDoFuture.md)
for more details and examples on this approach.

## See also

Useful links:

- <https://doFuture.futureverse.org>

- <https://github.com/futureverse/doFuture>

- Report bugs at <https://github.com/futureverse/doFuture/issues>

## Author

**Maintainer**: Henrik Bengtsson <henrikb@braju.com>
([ORCID](https://orcid.org/0000-0002-7579-5165)) \[copyright holder\]

Authors:

- Henrik Bengtsson <henrikb@braju.com>
  ([ORCID](https://orcid.org/0000-0002-7579-5165)) \[copyright holder\]
