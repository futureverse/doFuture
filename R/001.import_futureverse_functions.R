## Private functions imported from 'future' and 'future.apply'
make_rng_seeds <- import_future("make_rng_seeds")
next_random_seed <- import_future("next_random_seed")
set_random_seed <- import_future("set_random_seed")
makeChunks <- import_future_apply("makeChunks")

## An environment must be imported when the package is loaded, otherwise
## we would get a copy and not share the state with 'future'
.debug <- NULL

import_future_functions <- function() {
  .debug <<- import_future(".debug", mode = "environment")
}
