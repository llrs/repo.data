# Links between help pages by package

Explore the relationship between CRAN packages and other packages. If
the target package is ambiguous it is omitted.

## Usage

``` r
cran_pkges_links(packages = NULL)
```

## Arguments

- packages:

  A vector with packages or `NULL` for all packages.

## Value

A data.frame with 6 columns: from_pkg, to_pkg, n (Number of links). `NA`
if not able to collect the data from CRAN.

## See also

Other links from CRAN:
[`cran_links()`](https://llrs.github.io/repo.data/reference/cran_links.md),
[`cran_pages_links()`](https://llrs.github.io/repo.data/reference/cran_pages_links.md),
[`cran_targets_links()`](https://llrs.github.io/repo.data/reference/cran_targets_links.md),
[`links()`](https://llrs.github.io/repo.data/reference/links.md)

## Examples

``` r
# \donttest{
cpkl <- cran_pkges_links()
#> Warning: Some links are distinct depending on the OS.
head(cpkl)
#>      from_pkg   to_pkg     n   
#> [1,] "AATtools" "AATtools" "3" 
#> [2,] "ABCoptim" "graphics" "3" 
#> [3,] "ABCoptim" "stats"    "3" 
#> [4,] "ABM"      "ABM"      "39"
#> [5,] "ACDm"     "Rsolnp"   "3" 
#> [6,] "ACDm"     "ggplot2"  "3" 
# }
```
