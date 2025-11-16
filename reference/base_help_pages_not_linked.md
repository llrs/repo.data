# Help pages without links

Help pages without links to other help pages. This makes harder to
navigate to related help pages.

## Usage

``` r
base_help_pages_not_linked()
```

## Value

A data.frame with two columns: Package and Source. `NA` if not able to
collect the data from CRAN.

## See also

Other functions related to BASE help pages:
[`base_help_cliques()`](https://llrs.github.io/repo.data/reference/base_help_cliques.md),
[`base_help_pages_wo_links()`](https://llrs.github.io/repo.data/reference/base_help_pages_wo_links.md)

## Examples

``` r
# \donttest{
bhnl <- base_help_pages_not_linked()
#> Warning: Some pages point to different places according to the OS.
#> Warning: Some links are distinct depending on the OS.
head(bhnl)
#>   Package              Source
#> 1    base        Constants.Rd
#> 2    base Foreign-internal.Rd
#> 3    base      ISOdatetime.Rd
#> 4    base       Last.value.Rd
#> 5    base         S3method.Rd
#> 6    base   StackOverflows.Rd
# }
```
