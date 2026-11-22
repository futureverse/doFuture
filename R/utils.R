## isFALSE() is available in R (>= 3.5.0)
if (!exists("isFALSE", mode = "function")) {
  isFALSE <- function(x) {
    is.logical(x) && length(x) == 1L && !is.na(x) && !x
  }
}
