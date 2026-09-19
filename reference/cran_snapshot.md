# Check CRAN package state on any given date

Given the available information which packages were on CRAN on a given
date?

## Usage

``` r
cran_snapshot(date)
```

## Arguments

- date:

  The date you want to check.

## Value

The data.frame with the packages and versions at a given date. `NA` if
not able to collect the data from CRAN.

## Note

Due to missing of CRAN comments some packages are not annotated when
were they archived and more packages than present might be returned for
any given date.

## See also

Other utilities:
[`cran_date()`](https://repo.data.llrs.dev/reference/cran_date.md),
[`cran_doom()`](https://repo.data.llrs.dev/reference/cran_doom.md),
[`duplicated_alias()`](https://repo.data.llrs.dev/reference/duplicated_alias.md),
[`package_date()`](https://repo.data.llrs.dev/reference/package_date.md),
[`package_repos()`](https://repo.data.llrs.dev/reference/package_repos.md),
[`repos_dependencies()`](https://repo.data.llrs.dev/reference/repos_dependencies.md),
[`update_dependencies()`](https://repo.data.llrs.dev/reference/update_dependencies.md)

## Examples

``` r
# \donttest{
cs <- cran_snapshot(Sys.Date() - 2)
#> Warning: There are 5 packages both archived and published
#> This indicate manual CRAN intervention.
head(cs)
#> [1] NA
# }
```
