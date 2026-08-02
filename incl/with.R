with(registerDoFuture(), {
  y <- foreach(x = 1:3) %dopar% { x^2 }
})

a_fcn_in_a_pkg <- function(xs) {
  foreach(x = xs) %dopar% { x^2 }
}

with(registerDoFuture(flavor = "%dofuture%"), {
  y <- a_fcn_in_a_pkg(1:3)
})


my_fcn <- function(xs) {
  ## Use registerDoFuture() for this function only and then
  ## revert back to the previously set foreach adapter
  with(registerDoFuture(), local = TRUE)
  
  foreach(x = xs) %dopar% { x^2 }
}

