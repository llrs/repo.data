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
[`cran_date()`](https://llrs.github.io/repo.data/reference/cran_date.md),
[`cran_doom()`](https://llrs.github.io/repo.data/reference/cran_doom.md),
[`duplicated_alias()`](https://llrs.github.io/repo.data/reference/duplicated_alias.md),
[`package_date()`](https://llrs.github.io/repo.data/reference/package_date.md),
[`package_repos()`](https://llrs.github.io/repo.data/reference/package_repos.md),
[`repos_dependencies()`](https://llrs.github.io/repo.data/reference/repos_dependencies.md),
[`update_dependencies()`](https://llrs.github.io/repo.data/reference/update_dependencies.md)

## Examples

``` r
# \donttest{
cs <- cran_snapshot(Sys.Date() -2 )
#> Warning: There are 3 packages both archived and published
#> This indicate manual CRAN intervention.
head(cs)
#>       Package            Datetime Version   User    Size   Status
#> 1          A3 2015-08-16 21:05:54   1.0.0 hornik   42810 archived
#> 2    AATtools 2024-08-16 09:10:08   0.0.3 ligges  252641  current
#> 3      ABACUS 2019-09-20 07:40:07   1.0.0 ligges   84194  current
#> 4     ABC.RAP 2016-10-20 08:52:18   0.9.0 hornik 4769661  current
#> 5  ABCDscores 2025-09-11 09:01:03   6.0.1 ligges  354017  current
#> 6 ABCExtremes 2013-05-15 08:45:56     1.0 hornik    5784 archived
# }
```
