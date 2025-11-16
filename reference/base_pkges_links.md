# Links between help pages by package

Explore the relationship between base R packages and other packages. If
the target package is ambiguous it is omitted.

## Usage

``` r
base_pkges_links(packages = NULL)
```

## Arguments

- packages:

  A vector with packages or `NULL` for all packages.

## Value

A data.frame with 6 columns: from_pkg, to_pkg, n (Number of links). `NA`
if not able to collect the data from CRAN.

## See also

Other links from R:
[`base_links()`](https://llrs.github.io/repo.data/reference/base_links.md),
[`base_pages_links()`](https://llrs.github.io/repo.data/reference/base_pages_links.md),
[`base_targets_links()`](https://llrs.github.io/repo.data/reference/base_targets_links.md)

## Examples

``` r
# \donttest{
bpkl <- base_pkges_links()
#> Retrieving base_targets_links, this might take a bit.
#> Caching results to be faster next call in this session.
head(bpkl)
#> [1] NA
# }
```
