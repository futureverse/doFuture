library(doFuture)

plan(sequential)

message("*** doFuture2() errors ...")

# Unknown foreach() arguments
res <- tryCatch({
  foreach(i = 1:3, .options.unknown = list()) %dofuture% { i }
}, error = identity)
stopifnot(inherits(res, "error"),
          grepl("Unknown foreach\\(\\) arguments", res$message))

# .export not supported
res <- tryCatch({
  foreach(i = 1:3, .export = "i") %dofuture% { i }
}, error = identity)
stopifnot(inherits(res, "error"),
          grepl("foreach\\(\\) does not support argument '.export'", res$message))

# .noexport not supported
res <- tryCatch({
  foreach(i = 1:3, .noexport = "i") %dofuture% { i }
}, error = identity)
stopifnot(inherits(res, "error"),
          grepl("foreach\\(\\) does not support argument '.noexport'", res$message))

# .packages not supported
res <- tryCatch({
  foreach(i = 1:3, .packages = "utils") %dofuture% { i }
}, error = identity)
stopifnot(inherits(res, "error"),
          grepl("foreach\\(\\) does not support argument '.packages'", res$message))

# Unknown value of '.options.future' element 'errors'
res <- tryCatch({
  foreach(i = 1:3, .options.future = list(errors = "unknown")) %dofuture% { i }
}, error = identity)
stopifnot(inherits(res, "error"),
          grepl("Unknown value of '.options.future' element 'errors'", res$message))

# Element 'errors' of '.options.future' should be of length one
res <- tryCatch({
  foreach(i = 1:3, .options.future = list(errors = c("foreach", "future"))) %dofuture% { i }
}, error = identity)
stopifnot(inherits(res, "error"),
          grepl("Element 'errors' of '.options.future' should be of length one", res$message))

# Unknown type of '.options.future' element 'errors'
res <- tryCatch({
  foreach(i = 1:3, .options.future = list(errors = 1L)) %dofuture% { i }
}, error = identity)
stopifnot(inherits(res, "error"),
          grepl("Unknown type of '.options.future' element 'errors'", res$message))

message("*** doFuture2() errors ... DONE")
