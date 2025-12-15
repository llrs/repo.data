# Look at the CRAN actions db

CRAN tracks movements of packages and the actions used (for example to
report the number of manual actions taken by the volunteers).

## Usage

``` r
cran_actions(packages = NULL, silent = FALSE)
```

## Arguments

- packages:

  A vector with packages or `NULL` for all packages.

## Value

A data.frame with Date, Time, User, Action, Package and Version columns.
`NA` if not able to collect the data from CRAN.

## Examples

``` r
# ca <- cran_actions()
```
