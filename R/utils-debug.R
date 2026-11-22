## Debug functions specific to 'doFuture'. The other debug functions
## are imported from 'future'; see 001.import_futureverse_functions.R

# Get or set current stack
mdebug_stack <- function(stack = NULL) {
  if (!is.null(stack)) .debug$stack <- stack
  invisible(.debug$stack)
}

## Contrary to future:::mdebug_pop(), mdebug_pop(NA) pops the stack
## without outputting a message
mdebug_pop <- function(...) {
  n <- length(.debug$stack)
  msg <- c(...)
  if (length(msg) == 0) {
    msg <- .debug$stack[n]
    msg <- sprintf("%s done", msg)
  }
  .debug$stack <- .debug$stack[-n]
  if (length(msg) == 0 || !is.na(msg)) mdebug(msg)
}
