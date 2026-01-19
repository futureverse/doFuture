# Evaluate an Expression using a Temporarily Registered Foreach `%dopar%` Adapter

Evaluate an Expression using a Temporarily Registered Foreach `%dopar%`
Adapter

## Usage

``` r
# S3 method for class 'DoPar'
with(data, expr, ..., local = FALSE, envir = parent.frame())
```

## Arguments

- data:

  The foreach `%dopar%` adapter to use temporarily.

- expr:

  The R expression to be evaluated.

- local:

  If TRUE, then the future plan specified by `data` is applied
  temporarily in the calling frame. Argument `expr` must not be
  specified if `local = TRUE`.

- envir:

  The environment where the adapter should be set and the expression
  evaluated.

- ...:

  Not used.

## Value

The value of `expr` if `local = FALSE`, otherwise NULL invisibly.

## Examples

``` r
with(registerDoFuture(), {
  y <- foreach(x = 1:3) %dopar% { x^2 }
})
#> [[1]]
#> [1] 1
#> 
#> [[2]]
#> [1] 4
#> 
#> [[3]]
#> [1] 9
#> 

a_fcn_in_a_pkg <- function(xs) {
  foreach(x = xs) %dopar% { x^2 }
}

with(registerDoFuture(flavor = "%dofuture%"), {
  y <- a_fcn_in_a_pkg(1:3)
})
#> [[1]]
#> [1] 1
#> 
#> [[2]]
#> [1] 4
#> 
#> [[3]]
#> [1] 9
#> 


my_fcn <- function(xs) {
  ## Use registerDoFuture() for this function only and then
  ## revert back to the previously set foreach adapter
  with(registerDoFuture(), local = TRUE)
  
  foreach(x = xs) %dopar% { x^2 }
}
```
