# Options used by the doFuture adapter

Below are all R options specific to the doFuture package. For options
controlling futures in general, see [the
options](https://future.futureverse.org/reference/zzz-future.options.html)
for the future package.  
  
*WARNING: Note that the names and the default values of these options
may change in future versions of the package. Please use with care until
further notice.*

## Details

- doFuture.foreach.export::

  Specifies to what extent the `.export` argument of
  [`foreach()`](https://rdrr.io/pkg/foreach/man/foreach.html) should be
  respected or if globals should be automatically identified.

  If `".export"`, then the globals specified by the `.export` argument
  will be used "as is".

  If `".export-and-automatic"`, then globals specified by `.export` as
  well as those automatically identified are used.

  The `".export-and-automatic-with-warning"` is the same as
  `".export-and-automatic"`, but produces a warning if `.export` lacks
  some of the globals that the automatic identification locates

  - this is helpful feedback to developers using
    [`foreach()`](https://rdrr.io/pkg/foreach/man/foreach.html).

  (Default: `".export-and-automatic"`)

- doFuture.debug::

  If `TRUE`, extensive debug messages are generated. (Default: `FALSE`)

## Environment variables that set R options

All of the above R doFfuture.\* options can be set by corresponding
environment variable `R_FOFUTURE_*` *when the doFuture package is
loaded*. For example, if `R_DOFUTURE_DEBUG=TRUE`, then option
doFuture.debug is set to `TRUE` (logical).
