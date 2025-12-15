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
#> Warning: Some pages point to different places according to the OS.
#> Warning: Some links are distinct depending on the OS.
head(bpkl)
#>   from_pkg   to_pkg n
#> 1     base    round 1
#> 2     base     date 1
#> 3     base    chron 1
#> 4     base    tcltk 1
#> 5     base parallel 1
#> 6     base     nnet 1
# }
```
