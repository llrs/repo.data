# Help pages without links

Help pages without links to other help pages. This makes harder to
navigate to related help pages.

## Usage

``` r
cran_help_pages_not_linked(packages = NULL)
```

## Arguments

- packages:

  A vector with packages or `NULL` for all packages.

## Value

A data.frame with two columns: Package and Source `NA` if not able to
collect the data from CRAN.

## See also

Other functions related to CRAN help pages:
[`cran_help_cliques()`](https://llrs.github.io/repo.data/reference/cran_help_cliques.md),
[`cran_help_pages_wo_links()`](https://llrs.github.io/repo.data/reference/cran_help_pages_wo_links.md)

## Examples

``` r
# \donttest{
ap <- available.packages()
if (NROW(ap)) {
    a_package <- rownames(ap)[startsWith(rownames(ap), "A")][1]
    chnl <- cran_help_pages_not_linked(a_package)
    head(chnl)
}
#> Warning: Some links are distinct depending on the OS.
#>         Package            Source
#> 1 AalenJohansen aalen_johansen.Rd
#> 2 AalenJohansen        prodint.Rd
#> 3 AalenJohansen       sim_path.Rd
# }
```
