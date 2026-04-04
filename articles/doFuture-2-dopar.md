# Foreach Iteration using Futures via %dopar%

## Introduction

The **[doFuture](https://cran.r-project.org/package=doFuture)** package
provides a `%dopar%` adapter for the
**[foreach](https://cran.r-project.org/package=foreach)** package that
works with *any* type of future backend. The **doFuture** package is
cross platform just as the **future** package.

Below is an example showing how to make `%dopar%` work with
*multisession* futures. A multisession future will be evaluated in
parallel using background R process.

``` r

library("doFuture")
registerDoFuture()
plan(multisession)

cutoff <- 0.10
y <- foreach(x = mtcars, .export = c("cutoff")) %dopar% {
  mean(x, trim = cutoff)
}
names(y) <- colnames(mtcars)
```

## Futures bring foreach to the HPC cluster

To do the same on a high-performance computing (HPC) cluster, the
**[future.batchtools](https://cran.r-project.org/package=future.batchtools)**
package can be used. Assuming batchtools has been configured correctly,
then the following foreach iterations will be submitted to the HPC job
scheduler and distributed for evaluation on the compute nodes.

``` r

library("doFuture")
registerDoFuture()
plan(future.batchtools::batchtools_slurm)

cutoff <- 0.10
y <- foreach(x = mtcars, .export = c("cutoff")) %dopar% {
  mean(x, trim = cutoff)
}
names(y) <- colnames(mtcars)
```

## Futures for plyr

The **[plyr](https://cran.r-project.org/package=plyr)** package uses
**[foreach](https://cran.r-project.org/package=foreach)** as a parallel
backend. This means that with
**[doFuture](https://cran.r-project.org/package=doFuture)** any type of
futures can be used for asynchronous (and synchronous) **plyr**
processing including multicore, multisession, MPI, ad hoc clusters and
HPC job schedulers. For example,

``` r

library("doFuture")
registerDoFuture()
plan(multisession)
library("plyr")

cutoff <- 0.10
y <- llply(mtcars, mean, trim = cutoff, .parallel = TRUE)
## $a
##  25%  50%  75%
## 3.25 5.50 7.75
##
## $beta
##       25%       50%       75%
## 0.2516074 1.0000000 5.0536690
##
## $logic
## 25% 50% 75%
## 0.0 0.5 1.0
```

## Futures and BiocParallel

The
**[BiocParallel](https://bioconductor.org/packages/release/bioc/html/BiocParallel.html)**
package supports any `%dopar%` adapter as a parallel backend. This means
that with **[doFuture](https://cran.r-project.org/package=doFuture)**,
**BiocParallel** supports any type of future. For example,

``` r

library("doFuture")
registerDoFuture()
plan(multisession)
library("BiocParallel")
register(DoparParam(), default = TRUE)

cutoff <- 0.10
x <- bplapply(mtcars, mean, trim = cutoff)
```

## doFuture takes care of exports and packages automatically

The **foreach** package itself has some support for automated handling
of globals but unfortunately it does not work in all cases.
Specifically, if
[`foreach()`](https://rdrr.io/pkg/foreach/man/foreach.html) is called
from within a function, you do need to export globals explicitly. For
example, although global `cutoff` is properly exported when we do

``` r

library("doParallel")
registerDoParallel(parallel::makeCluster(2))

cutoff <- 0.10
y <- foreach(x = mtcars) %dopar% {
  mean(x, trim = cutoff)
}
names(y) <- colnames(mtcars)
```

it falls short as soon as we try to do the same from within a function:

``` r

my_mean <- function() {
  y <- foreach(x = mtcars) %dopar% {
    mean(x, trim = cutoff)
  }
  names(y) <- colnames(mtcars)
  y
}

x <- my_mean()
## Error in { : task 1 failed - "object 'cutoff' not found"
```

The solution is to explicitly export global variables, e.g.

``` r

my_mean <- function() {
  y <- foreach(x = mtcars, .export = "cutoff") %dopar% {
    mean(x, trim = cutoff)
  }
  names(y) <- colnames(mtcars)
  y
}

y <- my_mean()
```

In contrast, when using the `%dopar%` adapter of **doFuture**, all of
the **[future](https://cran.r-project.org/package=future)** machinery
comes into play including automatic handling of global variables, e.g.

``` r

library("doFuture")
registerDoFuture()
plan(multisession, workers = 2)

my_mean <- function() {
  y <- foreach(x = mtcars) %dopar% {
    mean(x, trim = cutoff)
  }
  names(y) <- colnames(mtcars)
  y
}

x <- my_mean()
```

will indeed work.

Another advantage with **doFuture** is that, contrary to **doParallel**,
packages that need to be attached are also automatically taken care of,
e.g.

``` r

registerDoFuture()
library("tools")
ext <- foreach(file = c("abc.txt", "def.log")) %dopar% file_ext(file)
unlist(ext)
## [1] "txt" "log"
```

whereas

``` r

registerDoParallel(parallel::makeCluster(2))
library("tools")
ext <- foreach(file = c("abc.txt", "def.log")) %dopar% file_ext(file)
## Error in file_ext(file) : 
##   task 1 failed - "could not find function "file_ext""
```

Having said all this, in order to write foreach code that works
everywhere, it is better to be conservative and not assume that all end
users will use a **doFuture** backend. Because of this, it is still
recommended to explicitly specify all objects that need to be exported
whenever using the foreach API. The **doFuture** framework can help you
identify what should go into the `.export` argument. By setting
`options(doFuture.foreach.export = ".export-and-automatic-with-warning")`,
**doFuture** will warn if it finds globals not listed in `.export` and
produce an informative warning message suggesting that those should be
added. To assert that argument `.export` is correct, test the code with
`options(doFuture.foreach.export = ".export")`, which will disable
automatic identification of globals such that only the globals specified
by the `.export` argument are used.

## doFuture replaces existing doNnn packages

Due to the generic nature of futures, the
**[doFuture](https://cran.r-project.org/package=doFuture)** package
provides the same functionality as many of the existing doNnn packages
combined, e.g. **[doMC](https://cran.r-project.org/package=doMC)**,
**[doParallel](https://cran.r-project.org/package=doParallel)**,
**[doMPI](https://cran.r-project.org/package=doMPI)**, and
**[doSNOW](https://cran.r-project.org/package=doSNOW)**.

[TABLE]
