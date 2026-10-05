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

\
[`library`](https://rdrr.io/r/base/library.html)`(`[`"doFuture"`](https://doFuture.futureverse.org)`)`\
[`registerDoFuture`](https://doFuture.futureverse.org/reference/registerDoFuture.md)`(``)`\
[`plan`](https://future.futureverse.org/reference/plan.html)`(``multisession``)`\
\
`cutoff`` ``<-`` ``0.10`\
`y`` ``<-`` `[`foreach`](https://rdrr.io/pkg/foreach/man/foreach.html)`(``x ``=`` ``mtcars``, .export ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(``"cutoff"``)``)`` `[`%dopar%`](https://rdrr.io/pkg/foreach/man/foreach.html)` ``{`\
`  `[`mean`](https://rdrr.io/r/base/mean.html)`(``x``, trim ``=`` ``cutoff``)`\
`}`\
[`names`](https://rdrr.io/r/base/names.html)`(``y``)`` ``<-`` `[`colnames`](https://rdrr.io/r/base/colnames.html)`(``mtcars``)`

## Futures bring foreach to the HPC cluster

To do the same on a high-performance computing (HPC) cluster, the
**[future.batchtools](https://cran.r-project.org/package=future.batchtools)**
package can be used. Assuming batchtools has been configured correctly,
then the following foreach iterations will be submitted to the HPC job
scheduler and distributed for evaluation on the compute nodes.

\
[`library`](https://rdrr.io/r/base/library.html)`(`[`"doFuture"`](https://doFuture.futureverse.org)`)`\
[`registerDoFuture`](https://doFuture.futureverse.org/reference/registerDoFuture.md)`(``)`\
[`plan`](https://future.futureverse.org/reference/plan.html)`(``future.batchtools``::`[`batchtools_slurm`](https://future.batchtools.futureverse.org/reference/batchtools_slurm.html)`)`\
\
`cutoff`` ``<-`` ``0.10`\
`y`` ``<-`` `[`foreach`](https://rdrr.io/pkg/foreach/man/foreach.html)`(``x ``=`` ``mtcars``, .export ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(``"cutoff"``)``)`` `[`%dopar%`](https://rdrr.io/pkg/foreach/man/foreach.html)` ``{`\
`  `[`mean`](https://rdrr.io/r/base/mean.html)`(``x``, trim ``=`` ``cutoff``)`\
`}`\
[`names`](https://rdrr.io/r/base/names.html)`(``y``)`` ``<-`` `[`colnames`](https://rdrr.io/r/base/colnames.html)`(``mtcars``)`

## Futures for plyr

The **[plyr](https://cran.r-project.org/package=plyr)** package uses
**[foreach](https://cran.r-project.org/package=foreach)** as a parallel
backend. This means that with
**[doFuture](https://cran.r-project.org/package=doFuture)** any type of
futures can be used for asynchronous (and synchronous) **plyr**
processing including multicore, multisession, MPI, ad hoc clusters and
HPC job schedulers. For example,

\
[`library`](https://rdrr.io/r/base/library.html)`(`[`"doFuture"`](https://doFuture.futureverse.org)`)`\
[`registerDoFuture`](https://doFuture.futureverse.org/reference/registerDoFuture.md)`(``)`\
[`plan`](https://future.futureverse.org/reference/plan.html)`(``multisession``)`\
[`library`](https://rdrr.io/r/base/library.html)`(`[`"plyr"`](http://had.co.nz/plyr)`)`\
\
`cutoff`` ``<-`` ``0.10`\
`y`` ``<-`` `[`llply`](https://rdrr.io/pkg/plyr/man/llply.html)`(``mtcars``, ``mean``, trim ``=`` ``cutoff``, .parallel ``=`` ``TRUE``)`\
`## $a`\
`##  25%  50%  75%`\
`## 3.25 5.50 7.75`\
`##`\
`## $beta`\
`##       25%       50%       75%`\
`## 0.2516074 1.0000000 5.0536690`\
`##`\
`## $logic`\
`## 25% 50% 75%`\
`## 0.0 0.5 1.0`

## Futures and BiocParallel

The
**[BiocParallel](https://bioconductor.org/packages/release/bioc/html/BiocParallel.html)**
package supports any `%dopar%` adapter as a parallel backend. This means
that with **[doFuture](https://cran.r-project.org/package=doFuture)**,
**BiocParallel** supports any type of future. For example,

\
[`library`](https://rdrr.io/r/base/library.html)`(`[`"doFuture"`](https://doFuture.futureverse.org)`)`\
[`registerDoFuture`](https://doFuture.futureverse.org/reference/registerDoFuture.md)`(``)`\
[`plan`](https://future.futureverse.org/reference/plan.html)`(``multisession``)`\
[`library`](https://rdrr.io/r/base/library.html)`(``"BiocParallel"``)`\
`register``(``DoparParam``(``)``, default ``=`` ``TRUE``)`\
\
`cutoff`` ``<-`` ``0.10`\
`x`` ``<-`` ``bplapply``(``mtcars``, ``mean``, trim ``=`` ``cutoff``)`

## doFuture takes care of exports and packages automatically

The **foreach** package itself has some support for automated handling
of globals but unfortunately it does not work in all cases.
Specifically, if
[`foreach()`](https://rdrr.io/pkg/foreach/man/foreach.html) is called
from within a function, you do need to export globals explicitly. For
example, although global `cutoff` is properly exported when we do

\
[`library`](https://rdrr.io/r/base/library.html)`(`[`"doParallel"`](https://github.com/RevolutionAnalytics/doparallel)`)`\
[`registerDoParallel`](https://rdrr.io/pkg/doParallel/man/registerDoParallel.html)`(``parallel``::`[`makeCluster`](https://rdrr.io/r/parallel/makeCluster.html)`(``2``)``)`\
\
`cutoff`` ``<-`` ``0.10`\
`y`` ``<-`` `[`foreach`](https://rdrr.io/pkg/foreach/man/foreach.html)`(``x ``=`` ``mtcars``)`` `[`%dopar%`](https://rdrr.io/pkg/foreach/man/foreach.html)` ``{`\
`  `[`mean`](https://rdrr.io/r/base/mean.html)`(``x``, trim ``=`` ``cutoff``)`\
`}`\
[`names`](https://rdrr.io/r/base/names.html)`(``y``)`` ``<-`` `[`colnames`](https://rdrr.io/r/base/colnames.html)`(``mtcars``)`

it falls short as soon as we try to do the same from within a function:

\
`my_mean`` ``<-`` ``function``(``)`` ``{`\
`  ``y`` ``<-`` `[`foreach`](https://rdrr.io/pkg/foreach/man/foreach.html)`(``x ``=`` ``mtcars``)`` `[`%dopar%`](https://rdrr.io/pkg/foreach/man/foreach.html)` ``{`\
`    `[`mean`](https://rdrr.io/r/base/mean.html)`(``x``, trim ``=`` ``cutoff``)`\
`  ``}`\
`  `[`names`](https://rdrr.io/r/base/names.html)`(``y``)`` ``<-`` `[`colnames`](https://rdrr.io/r/base/colnames.html)`(``mtcars``)`\
`  ``y`\
`}`\
\
`x`` ``<-`` ``my_mean``(``)`\
`## Error in { : task 1 failed - "object 'cutoff' not found"`

The solution is to explicitly export global variables, e.g.

\
`my_mean`` ``<-`` ``function``(``)`` ``{`\
`  ``y`` ``<-`` `[`foreach`](https://rdrr.io/pkg/foreach/man/foreach.html)`(``x ``=`` ``mtcars``, .export ``=`` ``"cutoff"``)`` `[`%dopar%`](https://rdrr.io/pkg/foreach/man/foreach.html)` ``{`\
`    `[`mean`](https://rdrr.io/r/base/mean.html)`(``x``, trim ``=`` ``cutoff``)`\
`  ``}`\
`  `[`names`](https://rdrr.io/r/base/names.html)`(``y``)`` ``<-`` `[`colnames`](https://rdrr.io/r/base/colnames.html)`(``mtcars``)`\
`  ``y`\
`}`\
\
`y`` ``<-`` ``my_mean``(``)`

In contrast, when using the `%dopar%` adapter of **doFuture**, all of
the **[future](https://cran.r-project.org/package=future)** machinery
comes into play including automatic handling of global variables, e.g.

\
[`library`](https://rdrr.io/r/base/library.html)`(`[`"doFuture"`](https://doFuture.futureverse.org)`)`\
[`registerDoFuture`](https://doFuture.futureverse.org/reference/registerDoFuture.md)`(``)`\
[`plan`](https://future.futureverse.org/reference/plan.html)`(``multisession``, workers ``=`` ``2``)`\
\
`my_mean`` ``<-`` ``function``(``)`` ``{`\
`  ``y`` ``<-`` `[`foreach`](https://rdrr.io/pkg/foreach/man/foreach.html)`(``x ``=`` ``mtcars``)`` `[`%dopar%`](https://rdrr.io/pkg/foreach/man/foreach.html)` ``{`\
`    `[`mean`](https://rdrr.io/r/base/mean.html)`(``x``, trim ``=`` ``cutoff``)`\
`  ``}`\
`  `[`names`](https://rdrr.io/r/base/names.html)`(``y``)`` ``<-`` `[`colnames`](https://rdrr.io/r/base/colnames.html)`(``mtcars``)`\
`  ``y`\
`}`\
\
`x`` ``<-`` ``my_mean``(``)`

will indeed work.

Another advantage with **doFuture** is that, contrary to **doParallel**,
packages that need to be attached are also automatically taken care of,
e.g.

\
[`registerDoFuture`](https://doFuture.futureverse.org/reference/registerDoFuture.md)`(``)`\
[`library`](https://rdrr.io/r/base/library.html)`(``"tools"``)`\
`ext`` ``<-`` `[`foreach`](https://rdrr.io/pkg/foreach/man/foreach.html)`(``file ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(``"abc.txt"``, ``"def.log"``)``)`` `[`%dopar%`](https://rdrr.io/pkg/foreach/man/foreach.html)` `[`file_ext`](https://rdrr.io/r/tools/fileutils.html)`(``file``)`\
[`unlist`](https://rdrr.io/r/base/unlist.html)`(``ext``)`\
`## [1] "txt" "log"`

whereas

\
[`registerDoParallel`](https://rdrr.io/pkg/doParallel/man/registerDoParallel.html)`(``parallel``::`[`makeCluster`](https://rdrr.io/r/parallel/makeCluster.html)`(``2``)``)`\
[`library`](https://rdrr.io/r/base/library.html)`(``"tools"``)`\
`ext`` ``<-`` `[`foreach`](https://rdrr.io/pkg/foreach/man/foreach.html)`(``file ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(``"abc.txt"``, ``"def.log"``)``)`` `[`%dopar%`](https://rdrr.io/pkg/foreach/man/foreach.html)` `[`file_ext`](https://rdrr.io/r/tools/fileutils.html)`(``file``)`\
`## Error in file_ext(file) : `\
`##   task 1 failed - "could not find function "file_ext""`

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
