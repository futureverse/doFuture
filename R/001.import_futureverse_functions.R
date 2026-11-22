## Private functions imported from 'future' and 'future.apply'
make_rng_seeds <- import_future("make_rng_seeds")
next_random_seed <- import_future("next_random_seed")
set_random_seed <- import_future("set_random_seed")
stop_if_not <- import_future("stop_if_not")
hpaste <- import_future("hpaste")
trim <- import_future("trim")

## Debug functions imported from 'future'. Their output is controlled by
## argument 'debug', which defaults to R option 'future.debug'. Here, all
## calls are already conditioned on R option 'doFuture.debug' by the
## caller, so we default to 'debug = TRUE'
import_future_debug <- function(name) {
  fcn <- import_future(name)
  formals(fcn)[["debug"]] <- TRUE
  fcn
}
mdebug <- import_future_debug("mdebug")
mdebugf <- import_future_debug("mdebugf")
mdebug_push <- import_future_debug("mdebug_push")
mdebugf_push <- import_future_debug("mdebugf_push")
mdebugf_pop <- import_future_debug("mdebugf_pop")
mprint <- import_future_debug("mprint")
mstr <- import_future_debug("mstr")
makeChunks <- import_future_apply("makeChunks")

## An environment must be imported when the package is loaded, otherwise
## we would get a copy and not share the state with 'future'
.debug <- NULL

import_future_functions <- function() {
  .debug <<- import_future(".debug", mode = "environment")
}
