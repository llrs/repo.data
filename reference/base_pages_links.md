# Links between help pages by page

Explore the relationship between base R packages and other help pages.
If the target help page is ambiguous it is omitted.

## Usage

``` r
base_pages_links(packages = NULL)
```

## Arguments

- packages:

  A vector with packages or `NULL` for all packages.

## Value

A data.frame with 6 columns: from_pkg, from_Rd, to_pkg, to_Rd, n (Number
of links). `NA` if not able to collect the data from CRAN.

## See also

Other links from R:
[`base_links()`](https://llrs.github.io/repo.data/reference/base_links.md),
[`base_pkges_links()`](https://llrs.github.io/repo.data/reference/base_pkges_links.md),
[`base_targets_links()`](https://llrs.github.io/repo.data/reference/base_targets_links.md)

## Examples

``` r
# \donttest{
bpl <- base_pages_links()
#> Retrieving base_targets_links, this might take a bit.
#> Caching results to be faster next call in this session.
head(bpl)
#> [1] NA
# }
```
