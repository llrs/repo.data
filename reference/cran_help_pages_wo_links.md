# Help pages not linked

Help pages without links from other help pages. This makes harder to
find them.

## Usage

``` r
cran_help_pages_wo_links(packages = NULL)
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
[`cran_help_pages_not_linked()`](https://llrs.github.io/repo.data/reference/cran_help_pages_not_linked.md)

## Examples

``` r
# \donttest{
ap <- available.packages()
if (NROW(ap)) {
    a_package <- rownames(ap)[startsWith(rownames(ap), "a")][1]
    chwl <- cran_help_pages_wo_links(a_package)
    head(chwl)
}
#>   Package             Source
#> 1 aamatch     PeriMatched.Rd
#> 2 aamatch   PeriUnmatched.Rd
#> 3 aamatch aamatch-package.Rd
#> 4 aamatch         artless.Rd
# }
```
