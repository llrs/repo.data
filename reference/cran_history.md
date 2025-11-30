# Check package history on CRAN

It uses available information to provide the most accurate information
of CRAN at any given time.

## Usage

``` r
cran_history(packages = NULL)
```

## Arguments

- packages:

  A vector with packages or `NULL` for all packages.

## Value

A data.frame with the information to recreate CRAN at any point before
today. `NA` if not able to collect the data from CRAN.

## Details

Several sources are used: CRAN's database to check packages files and
versions, CRAN's volunteers actions for when packages are archived or
removed and CRAN's comments to fill in the gaps.

## See also

[`cran_archive()`](https://llrs.github.io/repo.data/reference/cran_archive.md),
[`cran_actions()`](https://llrs.github.io/repo.data/reference/cran_actions.md),
[`cran_comments()`](https://llrs.github.io/repo.data/reference/cran_comments.md).

Other meta info from CRAN:
[`cran_alias()`](https://llrs.github.io/repo.data/reference/cran_alias.md),
[`cran_archive()`](https://llrs.github.io/repo.data/reference/cran_archive.md),
[`cran_comments()`](https://llrs.github.io/repo.data/reference/cran_comments.md),
[`cran_links()`](https://llrs.github.io/repo.data/reference/cran_links.md),
[`links()`](https://llrs.github.io/repo.data/reference/links.md)

## Examples

``` r
cran_history
#> function (packages = NULL) 
#> {
#>     history <- save_state("cran_history", cran_all_history())
#>     if (is_not_data(history)) {
#>         return(NA)
#>     }
#>     check_packages(packages, NA)
#>     get_package_subset("cran_history", packages)
#> }
#> <bytecode: 0x55ccc4844ed8>
#> <environment: namespace:repo.data>
```
