library(doFuture)

future_version <- doFuture:::future_version
hpaste <- doFuture:::hpaste
mdebug <- doFuture:::mdebug
mdebugf <- doFuture:::mdebugf
mprint <- doFuture:::mprint
mstr <- doFuture:::mstr
seq_to_human <- doFuture:::seq_to_human
seq_to_intervals <- doFuture:::seq_to_intervals
stealth_sample.int <- doFuture:::stealth_sample.int
stop_if_not <- doFuture:::stop_if_not
trim <- doFuture:::trim
printf <- function(...) cat(sprintf(...))

message("*** internals ...")

message("*** future_version() ...")

ver <- future_version()
print(ver)
stopifnot(inherits(ver, "package_version"))

message("*** future_version() ... DONE")

message("*** hpaste() ...")

# Some vectors
x <- 1:6
y <- 10:1
z <- LETTERS[x]

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Abbreviation of output vector
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf("x = %s.\n", hpaste(x))
## x = 1, 2, 3, ..., 6.

printf("x = %s.\n", hpaste(x, maxHead = 2))
## x = 1, 2, ..., 6.

printf("x = %s.\n", hpaste(x, maxHead = 3)) # Default
## x = 1, 2, 3, ..., 6.

# It will never output 1, 2, 3, 4, ..., 6
printf("x = %s.\n", hpaste(x, maxHead = 4))
## x = 1, 2, 3, 4, 5 and 6.

# Showing the tail
printf("x = %s.\n", hpaste(x, maxHead = 1, maxTail = 2))
## x = 1, ..., 5, 6.

# Turning off abbreviation
printf("y = %s.\n", hpaste(y, maxHead = Inf))
## y = 10, 9, 8, 7, 6, 5, 4, 3, 2, 1

## ...or simply
printf("y = %s.\n", paste(y, collapse = ", "))
## y = 10, 9, 8, 7, 6, 5, 4, 3, 2, 1

# Change last separator
printf("x = %s.\n", hpaste(x, lastCollapse = " and "))
## x = 1, 2, 3, 4, 5 and 6.

# No collapse
stopifnot(all(hpaste(x, collapse = NULL) == x))

# Empty input
stopifnot(identical(hpaste(character(0)), character(0)))

message("*** hpaste() ... DONE")



message("*** mdebug ...")

for (debug in c(FALSE, TRUE)) {
  mdebug("debug=", debug, debug = debug)
  mdebugf("debug=%f\n", debug, debug = debug)
  mprint(list(debug = debug), debug = debug)
  mstr(list(debug = debug), debug = debug)
}

message("*** mdebug ... DONE")


message("- stealth_sample.int() ...")

if (exists(".Random.seed", envir = globalenv(), inherits = FALSE)) {
  rm(".Random.seed", envir = globalenv(), inherits = FALSE)
}

stopifnot(!exists(".Random.seed", envir = globalenv(), inherits = FALSE))
x <- stealth_sample.int(10L)
str(x)
stopifnot(!exists(".Random.seed", envir = globalenv(), inherits = FALSE))

set.seed(42L)
seed0 <- globalenv()[[".Random.seed"]]
stopifnot(!is.null(seed0))
x0 <- stealth_sample.int(10L)
str(x0)
seed <- globalenv()[[".Random.seed"]]
stopifnot(!is.null(seed), identical(seed, seed0))

x <- stealth_sample.int(10L)
str(x)
stopifnot(identical(x, x0))
seed <- globalenv()[[".Random.seed"]]
stopifnot(!is.null(seed), identical(seed, seed0))

message("- stealth_sample.int() ... DONE")


message("*** stop_if_not() ...")

stop_if_not()
stop_if_not(TRUE)
stop_if_not(TRUE, TRUE)

res <- tryCatch(stop_if_not(FALSE), error = identity)
stopifnot(inherits(res, "error"))

res <- tryCatch(stop_if_not(NA), error = identity)
stopifnot(inherits(res, "error"))

res <- tryCatch(stop_if_not(logical(0)), error = identity)
stopifnot(inherits(res, "error"))

res <- tryCatch(stop_if_not(c(TRUE, TRUE)), error = identity)
stopifnot(inherits(res, "error"))

res <- tryCatch(stop_if_not(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE), error = identity)
stopifnot(inherits(res, "error"))

message("*** stop_if_not() ... DONE")


message("*** trim() ...")
stopifnot(trim("  abc  ") == "abc")
stopifnot(trim("\t\n abc \f\r") == "abc")
stopifnot(trim("abc") == "abc")
stopifnot(trim("") == "")
stopifnot(trim("   ") == "")
stopifnot(trim("\t\t") == "")
stopifnot(trim(" a b c ") == "a b c")
message("*** trim() ... DONE")


message("*** seq_to_human() ...")

stopifnot(seq_to_human(1:3) == "1-3")
stopifnot(seq_to_human(c(1, 3, 4, 5)) == "1, 3-5")
stopifnot(seq_to_human(c(1, 2, 4, 6, 7, 8)) == "1-2, 4, 6-8")
stopifnot(seq_to_human(integer(0)) == "")

# Test with tau
stopifnot(seq_to_human(c(1, 2), tau = 2) == "1, 2")
stopifnot(seq_to_human(c(1, 2, 3), tau = 5) == "1, 2, 3")

message("*** seq_to_human() ... DONE")


message("*** internals ... DONE")
