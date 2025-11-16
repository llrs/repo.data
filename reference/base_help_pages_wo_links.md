# Help pages not linked from base R

Help pages without links from other help pages. This makes harder to
find them.

## Usage

``` r
base_help_pages_wo_links()
```

## Value

A data.frame with two columns: Package and Source

## See also

Other functions related to BASE help pages:
[`base_help_cliques()`](https://llrs.github.io/repo.data/reference/base_help_cliques.md),
[`base_help_pages_not_linked()`](https://llrs.github.io/repo.data/reference/base_help_pages_not_linked.md)

## Examples

``` r
# \donttest{
bhwl <- base_help_pages_wo_links()
#> Warning: Some pages point to different places according to the OS.
#> Warning: Some links are distinct depending on the OS.
head(bhwl)
#> [1] Package Source 
#> <0 rows> (or 0-length row.names)
# }
```
