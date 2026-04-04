# Options used by the doFuture adapter

Below are all R options specific to the doFuture package. For options
controlling futures in general, see [the
options](https://future.futureverse.org/reference/zzz-future.options.html)
for the future package.\
\
*WARNING: Note that the names and the default values of these options
may change in future versions of the package. Please use with care until
further notice.*

## Details

- doFuture.foreach.export::

  Specifies to what extent the `.export` argument of
  [`foreach::foreach()`](https://rdrr.io/pkg/foreach/man/foreach.html),
  paired with [`%dopar%`](https://rdrr.io/pkg/foreach/man/foreach.html),
  should be respected or if globals should be automatically identified.
  This is only for `%dopar%` –
  [`%dofuture%`](https://doFuture.futureverse.org/reference/grapes-dofuture-grapes.md)
  does not support `.export` and `.noexport`.

  If `".export"`, then the globals specified by the `.export` argument
  will be used "as is".

  If `".export-and-automatic"`, then globals specified by `.export` as
  well as those automatically identified are used.

  The `".export-and-automatic-with-warning"` is the same as
  `".export-and-automatic"`, but produces a warning if `.export` lacks
  some of the globals that the automatic identification locates, which
  could be helpful feedback to developers using
  [`foreach::foreach()`](https://rdrr.io/pkg/foreach/man/foreach.html)
  with `%dopar%` – also when using adapters such as **doParallel**.

  (Default: `".export-and-automatic"`)

- doFuture.debug::

  If `TRUE`, extensive debug messages are generated. (Default: `FALSE`)

## Environment variables that set R options

All of the above R doFuture.\* options can be set by corresponding
environment variable `R_DOFUTURE_*` *when the doFuture package is
loaded*. For example, if `R_DOFUTURE_DEBUG=TRUE`, then option
doFuture.debug is set to `TRUE` (logical).
