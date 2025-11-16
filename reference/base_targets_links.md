# Links between help pages by target

Explore the relationship between base R packages and other help pages by
the target they use.

## Usage

``` r
base_targets_links(packages = NULL)
```

## Arguments

- packages:

  A vector with packages or `NULL` for all packages.

## Value

A data.frame with 6 columns: from_pkg, from_Rd, to_pkg, to_target,
to_Rd, n (Number of links). `NA` if not able to collect the data from
CRAN.

## See also

Other links from R:
[`base_links()`](https://llrs.github.io/repo.data/reference/base_links.md),
[`base_pages_links()`](https://llrs.github.io/repo.data/reference/base_pages_links.md),
[`base_pkges_links()`](https://llrs.github.io/repo.data/reference/base_pkges_links.md)

## Examples

``` r
# \donttest{
btl <- base_targets_links()
head(btl)
#> [1] NA
# }
```
