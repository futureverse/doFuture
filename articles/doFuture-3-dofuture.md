# Foreach Iteration using Futures via %dofuture%

In addition to providing a
**[foreach](https://cran.r-project.org/package=foreach)** adapter to be
used with the `%dopar%` operator of **foreach**, the
**[doFuture](https://cran.r-project.org/package=doFuture)** package
provides an alternative
[`foreach()`](https://rdrr.io/pkg/foreach/man/foreach.html) operator
called `%dofuture%` that ties more directly into the
**[future](https://cran.r-project.org/package=future)** framework. For
example,

\
[`library`](https://rdrr.io/r/base/library.html)`(`[`doFuture`](https://doFuture.futureverse.org)`)`\
[`plan`](https://future.futureverse.org/reference/plan.html)`(``multisession``)`\
\
`cutoff`` ``<-`` ``0.10`\
`y`` ``<-`` `[`foreach`](https://rdrr.io/pkg/foreach/man/foreach.html)`(``x ``=`` ``mtcars``, .export ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(``"cutoff"``)``)`` `[`%dofuture%`](https://doFuture.futureverse.org/reference/grapes-dofuture-grapes.md)` ``{`\
`  `[`mean`](https://rdrr.io/r/base/mean.html)`(``x``, trim ``=`` ``cutoff``)`\
`}`\
[`names`](https://rdrr.io/r/base/names.html)`(``y``)`` ``<-`` `[`colnames`](https://rdrr.io/r/base/colnames.html)`(``mtcars``)`

There are several advantages of using `%dofuture%` instead of `%dopar%`.
When you use `%dofuture%`,

- there is no need to use
  [`registerDoFuture()`](https://doFuture.futureverse.org/reference/registerDoFuture.md)

- there is no need to use `%dorng%` of the **doRNG** package (but you
  need to specify `.options.future = list(seed = TRUE)` whenever using
  random numbers in the `expr` expression)

- global variables and packages are identified automatically by the
  **future** framework

- errors are relayed as-is (with `%dopar%` they are captured and
  modified)

This makes `foreach(...) %dofuture% { ... }` more in line with how
sibling packages **future.apply** and **furrr** work.

## Global variables and packages

When using `%dofuture%`, the future framework identifies globals and
packages automatically (via static code inspection).

However, there are cases where it fails to find some of the globals or
packages. When this happens, one can specify the
[`future()`](https://future.futureverse.org/reference/future.html)
arguments `globals` and `packages` via foreach argument
`.options.future`. For example, if you specify argument
`.options.future = list(globals = structure(TRUE, ignore = "b", add = "a"))`
then globals are automatically identified (`TRUE`), but it ignores `b`
and always adds `a`.

An alternative to specifying the `globals` and the `packages` options
via `.options.future`, is to use the `%globals%` and `%packages%`
operators.

For further details and instructions, see
[`help("future", package = "future")`](https://future.futureverse.org/reference/future.html).

## Random Number Generation (RNG)

The `%dofuture%` uses the future ecosystem to generate proper random
numbers in parallel in the same way they are generated in, for instance,
**future.apply** and **furrr**. For this to work, you need to specify
`.options.future = list(seed = TRUE)`. For example,

\
`y`` ``<-`` `[`foreach`](https://rdrr.io/pkg/foreach/man/foreach.html)`(``i ``=`` ``1``:``3``, .options.future ``=`` `[`list`](https://rdrr.io/r/base/list.html)`(``seed ``=`` ``TRUE``)``)`` `[`%dofuture%`](https://doFuture.futureverse.org/reference/grapes-dofuture-grapes.md)` ``{`\
`  `[`rnorm`](https://rdrr.io/r/stats/Normal.html)`(``1``)`\
`}`

An alternative to specifying the `seed` option via `.options.future`, is
to use the `%seed%` operator.

\
`y`` ``<-`` `[`foreach`](https://rdrr.io/pkg/foreach/man/foreach.html)`(``i ``=`` ``1``:``3``)`` `[`%dofuture%`](https://doFuture.futureverse.org/reference/grapes-dofuture-grapes.md)` ``{`\
`  `[`rnorm`](https://rdrr.io/r/stats/Normal.html)`(``1``)`\
`}`` `[`%seed%`](https://future.futureverse.org/reference/futureAssign.html)` ``TRUE`

For further details and instructions, see
[`help("future", package = "future")`](https://future.futureverse.org/reference/future.html).

## Load balancing (“chunking”)

Whether load balancing (“chunking”) should take place or not can be
controlled by specifying either argument
`.options.future = list(scheduling = <ratio>)` or
`.options.future = list(chunk.size = <count>)` to
[`foreach()`](https://rdrr.io/pkg/foreach/man/foreach.html). For
example,

\
`y`` ``<-`` `[`foreach`](https://rdrr.io/pkg/foreach/man/foreach.html)`(``x ``=`` ``1``:``10``, .options.future ``=`` `[`list`](https://rdrr.io/r/base/list.html)`(``scheduling ``=`` ``2.0``)``)`` `[`%dofuture%`](https://doFuture.futureverse.org/reference/grapes-dofuture-grapes.md)` ``{`\
`  ``slow_fcn``(``x``)`\
`}`

For further details and instructions, see
[`help("future_lapply", package = "future.apply")`](https://future.apply.futureverse.org/reference/future_lapply.html).
