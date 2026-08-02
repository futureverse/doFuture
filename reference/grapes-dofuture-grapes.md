# Loop over a Foreach Expression using Futures

Loop over a Foreach Expression using Futures

## Usage

``` r
foreach %dofuture% expr
```

## Arguments

- foreach:

  A `foreach` object created by
  [`foreach::foreach()`](https://rdrr.io/pkg/foreach/man/foreach.html)
  and
  [`foreach::times()`](https://rdrr.io/pkg/foreach/man/foreach.html).

- expr:

  An R expression.

## Value

The value of the foreach call.

## Details

This is a replacement for `%dopar%` of the foreach package that
leverages the future framework.

When using `%dofuture%`:

- there is no need to use
  [`registerDoFuture()`](https://doFuture.futureverse.org/reference/registerDoFuture.md)

- there is no need to use `%dorng%` of the **doRNG** package (but you
  need to specify `.options.future = list(seed = TRUE)` whenever using
  random numbers in the `expr` expression)

- global variables and packages are identified automatically by the
  future framework

- errors are relayed as-is with the default `.errorhandling = "stop"`,
  whereas with `%dopar%` they are captured and modified.

## Global variables and packages

When using `%dofuture%`, the future framework identifies globals and
packages automatically (via static code inspection). However, there are
cases where it fails to find some of the globals or packages. When this
happens, one can specify the
[`future::future()`](https://future.futureverse.org/reference/future.html)
arguments `globals` and `packages` via foreach argument
`.options.future`. For example, if you specify argument
`.options.future = list(globals = structure(TRUE, ignore = "b", add = "a"))`
then globals are automatically identified (`TRUE`), but it ignores `b`
and always adds `a`.

An alternative to specifying the `globals` and the `packages` options
via `.options.future`, is to use the
[`%globals%`](https://future.futureverse.org/reference/futureAssign.html)
and the
[`%packages%`](https://future.futureverse.org/reference/futureAssign.html)
operators. See the examples for an illustration.

For further details and instructions, see
[`future::future()`](https://future.futureverse.org/reference/future.html).

## Random Number Generation (RNG)

The `%dofuture%` operator uses the future ecosystem to generate proper
random numbers in parallel in the same way they are generated in, for
instance, future.apply. For this to work, you need to specify
`.options.future = list(seed = TRUE)`. For example,

    y <- foreach(i = 1:3, .options.future = list(seed = TRUE)) %dofuture% {
      rnorm(1)
    }

Unless `seed` is `FALSE` or `NULL`, this guarantees that the exact same
sequence of random numbers is generated *given the same initial seed /
RNG state* - this regardless of type of future backend, number of
workers, and scheduling ("chunking") strategy.

RNG reproducibility is achieved by pregenerating the random seeds for
all iterations by parallel RNG streams. In each iteration, these seeds
are set before evaluating the foreach expression. *Note, for large
number of iterations this may introduce a large overhead.*

If `seed = TRUE`, then
[`.Random.seed`](https://rdrr.io/r/base/Random.html) is used if it holds
a parallel RNG seed, otherwise one is created randomly.

If `seed = FALSE`, it is expected that none of the foreach iterations
use random number generation. If they do, then an informative warning or
error is produced depending on settings. See
[future::future](https://future.futureverse.org/reference/future.html)
for more details. Using `seed = NULL` is like `seed = FALSE` but without
the check whether random numbers were generated or not.

As input, `seed` may also take a fixed initial seed (integer), either as
a full parallel RNG seed (vector of 1+6 integers), or as a seed
generating such a full seed. This seed will be used to generate one
parallel RNG stream for each iteration.

An alternative to specifying the `seed` option via `.options.future`, is
to use the
[`%seed%`](https://future.futureverse.org/reference/futureAssign.html)
operator. See the examples for an illustration.

For further details and instructions, see
[`future.apply::future_lapply()`](https://future.apply.futureverse.org/reference/future_lapply.html).

## Load balancing ("chunking")

Whether load balancing ("chunking") should take place or not can be
controlled by specifying either argument
`.options.future = list(scheduling = <ratio>)` or
`.options.future = list(chunk.size = <count>)` to
[`foreach()`](https://rdrr.io/pkg/foreach/man/foreach.html).

The value `chunk.size` specifies the average number of elements
processed per future ("chunks"). If `+Inf`, then all elements are
processed in a single future (one worker). If `NULL`, then argument
`future.scheduling` is used.

The value `scheduling` specifies the average number of futures
("chunks") that each worker processes. If `0.0`, then a single future is
used to process all iterations; none of the other workers are used. If
`1.0` or `TRUE`, then one future per worker is used. If `2.0`, then each
worker will process two futures (if there are enough iterations). If
`+Inf` or `FALSE`, then one future per iteration is used. The default
value is `scheduling = 1.0`.

For further details and instructions, see
[`future.apply::future_lapply()`](https://future.apply.futureverse.org/reference/future_lapply.html).

## Control processing order of iterations

Attribute `ordering` of `chunk.size` or `scheduling` can be used to
control the ordering of the elements are iterated over, which only
affects the processing order and *not* the order values are returned.
This attribute can take the following values:

- index vector - an numeric vector of length `nX`.

- function - an function taking one argument which is called as
  `ordering(nX)` and which must return an index vector of length `nX`,
  e.g. `function(n) rev(seq_len(n))` for reverse ordering.

- `"random"` - this will randomize the ordering via random index vector
  `sample.int(nX)`.

where `nX` is the number of foreach iterations to be done.

For example,
`.options.future = list(scheduling = structure(2.0, ordering = "random"))`.

*Note*, when elements are processed out of order, then captured standard
output and conditions are also relayed in that order, that is, out of
order.

For further details and instructions, see
[`future.apply::future_lapply()`](https://future.apply.futureverse.org/reference/future_lapply.html).

## Reporting on progress

How to report on progress is a frequently asked question, especially in
long-running tasks and parallel processing. The **foreach** framework
does *not* have a built-in mechanism for progress reporting(\*).

When using **doFuture**, and the Futureverse in general, for processing,
the **progressr** package can be used to signal progress updates in a
near-live fashion. There is no special argument related to
[`foreach()`](https://rdrr.io/pkg/foreach/man/foreach.html) or
**doFuture** to achieve this. Instead, one calls a, so called,
"progressor" function within each iteration. See the
[**progressr**](https://cran.r-project.org/package=progressr) package
and its `vignette(package = "progressr")` for examples.

(\*) The legacy **doSNOW** package uses a special
[`foreach()`](https://rdrr.io/pkg/foreach/man/foreach.html) argument
`.options.doSNOW$progress` that can be used to make a progress update
each time results from a parallel worker are returned. This approach is
limited by how chunking works, requires the developer to set that
argument, and the code becomes incompatible with foreach adaptors
registered by other **doNnn** packages.

## Examples

``` r
# \donttest{
plan(multisession)  # parallelize futures on the local machine

y <- foreach(x = 1:10, .combine = rbind) %dofuture% {
  y <- sqrt(x)
  data.frame(x = x, y = y, pid = Sys.getpid())
}
print(y)
#>     x        y    pid
#> 1   1 1.000000 149737
#> 2   2 1.414214 149737
#> 3   3 1.732051 149735
#> 4   4 2.000000 149736
#> 5   5 2.236068 149731
#> 6   6 2.449490 149732
#> 7   7 2.645751 149734
#> 8   8 2.828427 149730
#> 9   9 3.000000 149733
#> 10 10 3.162278 149733


## Random number generation
y <- foreach(i = 1:3, .combine = rbind, .options.future = list(seed = TRUE)) %dofuture% {
  data.frame(i = i, random = runif(n = 1L)) 
}
print(y)
#>   i    random
#> 1 1 0.5162133
#> 2 2 0.2298679
#> 3 3 0.6735465

## Random number generation (alternative specification)
y <- foreach(i = 1:3, .combine = rbind) %dofuture% {
  data.frame(i = i, random = runif(n = 1L)) 
} %seed% TRUE
print(y)
#>   i     random
#> 1 1 0.28884821
#> 2 2 0.05377184
#> 3 3 0.50333004

## Random number generation with the foreach() %:% nested operator
y <- foreach(i = 1:3, .combine = rbind) %:%
       foreach(j = 3:5, .combine = rbind, .options.future = list(seed = TRUE)) %dofuture% {
  data.frame(i = i, j = j, random = runif(n = 1L)) 
}
print(y)
#>   i j     random
#> 1 1 3 0.17985091
#> 2 1 4 0.73555548
#> 3 1 5 0.01429241
#> 4 2 3 0.02869343
#> 5 2 4 0.22387862
#> 6 2 5 0.70946015
#> 7 3 3 0.81536051
#> 8 3 4 0.78141131
#> 9 3 5 0.19762740

## Random number generation with the nested foreach() calls
y <- foreach(i = 1:3, .combine = rbind, .options.future = list(seed = TRUE)) %dofuture% {
  foreach(j = 3:5, .combine = rbind, .options.future = list(seed = TRUE)) %dofuture% {
    data.frame(i = i, j = j, random = runif(n = 1L)) 
  }
}
print(y)
#>   i j     random
#> 1 1 3 0.70081206
#> 2 1 4 0.37090526
#> 3 1 5 0.41776469
#> 4 2 3 0.37090526
#> 5 2 4 0.41776469
#> 6 2 5 0.07387902
#> 7 3 3 0.41776469
#> 8 3 4 0.07387902
#> 9 3 5 0.18763806

# }
```
