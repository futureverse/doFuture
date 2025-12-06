# doFuture: Foreach Parallel Adapter using Futures

The doFuture package provides mechanisms for using the foreach package
together with the future package such that
[`foreach()`](https://rdrr.io/pkg/foreach/man/foreach.html) parallelizes
via *any* future backend.

## Usage

There are two alternative ways to use this package:

1.  `y <- foreach(...) %dofuture% { ... }`

2.  `y <- foreach(...) %dopar% { ... }` with
    [`registerDoFuture()`](https://doFuture.futureverse.org/reference/registerDoFuture.md)

The *first alternative* (recommended), which uses
[`%dofuture%`](https://doFuture.futureverse.org/reference/grapes-dofuture-grapes.md),
avoids having to use
[`registerDoFuture()`](https://doFuture.futureverse.org/reference/registerDoFuture.md).
The
[`%dofuture%`](https://doFuture.futureverse.org/reference/grapes-dofuture-grapes.md)
operator provides a more consistent behavior than `%dopar%`, e.g. there
is a unique set of foreach arguments instead of one per possible
adapter. Identification of globals, random number generation (RNG), and
error handling is handled by the future ecosystem, just like with other
map-reduce solutions such as
**[future.apply](https://cran.r-project.org/package=future.apply)** and
**[furrr](https://cran.r-project.org/package=furrr)**. An example is:

    library(doFuture)
    plan(multisession)

    y <- foreach(x = 1:4, y = 1:10) %dofuture% {
      z <- x + y
      slow_sqrt(z)
    }

This alternative is the recommended way to let
[`foreach()`](https://rdrr.io/pkg/foreach/man/foreach.html) parallelize
via the future framework if you start out from scratch.

See
[`%dofuture%`](https://doFuture.futureverse.org/reference/grapes-dofuture-grapes.md)
for more details and examples on this approach.

The *second alternative* is based on the traditional **foreach**
approach where one registers a foreach adapter to be used by `%dopar%`.
A popular adapter is
[`doParallel::registerDoParallel()`](https://rdrr.io/pkg/doParallel/man/registerDoParallel.html),
which parallelizes on the local machine using the **parallel** package.
This package provides
[`registerDoFuture()`](https://doFuture.futureverse.org/reference/registerDoFuture.md),
which parallelizes using the **future** package, meaning any
future-compliant parallel backend can be used. An example is:

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
and functions that uses
[`foreach()`](https://rdrr.io/pkg/foreach/man/foreach.html) and
`%dopar%` internally, e.g.
**[caret](https://cran.r-project.org/package=caret)**,
**[plyr](https://cran.r-project.org/package=plyr)**,
**[NMF](https://cran.r-project.org/package=NMF)**, and
**[glmnet](https://cran.r-project.org/package=glmnet)**. It can also be
used to configure the Bioconductor
**[BiocParallel](https://bioconductor.org/packages/BiocParallel/)**
package, and any package that rely on it, to parallelize via the future
framework.

See
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
