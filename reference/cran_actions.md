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

- silent:

  A logical value to issue warnings about the data or not.

## Value

A data.frame with Date, Time, User, Action, Package and Version columns.
`NA` if not able to collect the data from CRAN.

## Details

There are three possible actions with packages source code: publish,
archive and remove.

- Publish: Add it to CRAN's PACKAGES file, users can install that
  version.

- Archive: Removed from CRAN's repository PACKAGES file so users can't
  access the package with
  [`available.packages()`](https://rdrr.io/r/utils/available.packages.html).
  Remains on CRAN archive:
  <https://cran.r-project.org/src/contrib/Archive/>.

- Remove: Removed from CRAN's archive.

## Examples

``` r
ca <- cran_actions(silent = TRUE)
head(ca)
#>         Date     Time   User  Action  Package Version
#> 1 2013-02-07 10:00:29 hornik publish       A3   0.9.1
#> 2 2013-03-26 19:58:40 ligges publish       A3   0.9.2
#> 3 2015-08-16 23:05:54 hornik publish       A3   1.0.0
#> 4 2025-06-13 10:12:00 hornik archive       A3   1.0.0
#> 5 2020-06-14 17:10:07 ligges publish AATtools   0.0.1
#> 6 2022-08-12 15:40:11 ligges publish AATtools   0.0.2
```
