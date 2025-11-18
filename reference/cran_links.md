# CRAN's links

Retrieve links on CRAN packages' R documentation files.

## Usage

``` r
cran_links(packages = NULL)
```

## Arguments

- packages:

  A vector with packages or `NULL` for all packages.

## Value

A data.frame with the links on CRAN's packages. It has 4 columns:
Package, Anchor, Target and Source. `NA` if not able to collect the data
from CRAN.

## See also

The raw source of the data is:
[`CRAN_rdxrefs_db()`](https://rdrr.io/r/tools/CRANtools.html).

Other links from CRAN:
[`cran_pages_links()`](https://llrs.github.io/repo.data/reference/cran_pages_links.md),
[`cran_pkges_links()`](https://llrs.github.io/repo.data/reference/cran_pkges_links.md),
[`cran_targets_links()`](https://llrs.github.io/repo.data/reference/cran_targets_links.md),
[`links()`](https://llrs.github.io/repo.data/reference/links.md)

Other meta info from CRAN:
[`cran_alias()`](https://llrs.github.io/repo.data/reference/cran_alias.md),
[`cran_archive()`](https://llrs.github.io/repo.data/reference/cran_archive.md),
[`cran_comments()`](https://llrs.github.io/repo.data/reference/cran_comments.md),
[`cran_history()`](https://llrs.github.io/repo.data/reference/cran_history.md),
[`links()`](https://llrs.github.io/repo.data/reference/links.md)

## Examples

``` r
cl <- cran_links("CytoSimplex")
head(cl)
#>       Package            Source                 Anchor                Target
#> 1 CytoSimplex     plotBinary.Rd                                  plotTernary
#> 2 CytoSimplex     plotBinary.Rd                ggplot2            geom_point
#> 3 CytoSimplex plotQuaternary.Rd                                  plotTernary
#> 4 CytoSimplex plotQuaternary.Rd                           writeQuaternaryGIF
#> 5 CytoSimplex plotQuaternary.Rd =plotQuaternary.simMat plotQuaternary.simMat
#> 6 CytoSimplex plotQuaternary.Rd                   grid                 arrow
```
