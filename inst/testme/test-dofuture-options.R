library(doFuture)
registerDoFuture()

plan(sequential)

message("*** %dofuture% with future option 'conditions' ...")

# 1. Capture and relay a specific condition
message("- Capture 'message' ...")
res <- foreach(i = 1:2, .options.future = list(conditions = "message")) %dofuture% {
  message("Hello from ", i)
  i
}
stopifnot(identical(res, list(1L, 2L)))

# 2. Don't capture any conditions
message("- Capture no conditions ...")
res <- withCallingHandlers({
  foreach(i = 1:2, .options.future = list(conditions = character(0))) %dofuture% {
    message("This should not be seen")
    i
  }
}, message = function(m) {
  stop("Message was unexpectedly captured: ", m$message)
})
stopifnot(identical(res, list(1L, 2L)))

message("*** %dofuture% with future option 'conditions' ... DONE")
