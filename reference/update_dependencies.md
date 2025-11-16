# Upgradable versions

Helper function to detect which package have a required version on the
dependencies that could be upgraded.

## Usage

``` r
update_dependencies(packages)
```

## Arguments

- packages:

  A character vector of packages names.

## Value

The data.frame filtered with some relevant rows. `NA` if not able to
collect the data from repositories.

## Details

Increasing this version requirements won't affect users as they already
should have these versions installed as required by other dependencies.

## See also

[`package_dependencies()`](https://llrs.github.io/repo.data/reference/package_dependencies.md)

Other utilities:
[`cran_date()`](https://llrs.github.io/repo.data/reference/cran_date.md),
[`cran_doom()`](https://llrs.github.io/repo.data/reference/cran_doom.md),
[`cran_snapshot()`](https://llrs.github.io/repo.data/reference/cran_snapshot.md),
[`duplicated_alias()`](https://llrs.github.io/repo.data/reference/duplicated_alias.md),
[`package_date()`](https://llrs.github.io/repo.data/reference/package_date.md),
[`package_repos()`](https://llrs.github.io/repo.data/reference/package_repos.md),
[`repos_dependencies()`](https://llrs.github.io/repo.data/reference/repos_dependencies.md)

## Examples

``` r
update_dependencies("arrow")
#>         Name Version
#> 1      cpp11   0.5.2
#> 2      rlang   1.1.6
#> 3   testthat 3.2.1.1
#> 4 tidyselect   1.2.1
```
