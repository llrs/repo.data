# Base R's links

Retrieve links on R documentation files.

## Usage

``` r
base_links(packages = NULL)
```

## Arguments

- packages:

  A vector with packages or `NULL` for all packages.

## Value

A data.frame with the links on R's files. It has 4 columns: Package,
Anchor, Target and Source. `NA` if not able to collect the data from
CRAN.

## See also

The raw source of the data is:
[`base_rdxrefs_db()`](https://rdrr.io/r/tools/basetools.html).

Other links from R:
[`base_pages_links()`](https://llrs.github.io/repo.data/reference/base_pages_links.md),
[`base_pkges_links()`](https://llrs.github.io/repo.data/reference/base_pkges_links.md),
[`base_targets_links()`](https://llrs.github.io/repo.data/reference/base_targets_links.md)

## Examples

``` r
# \donttest{
bl <- base_links()
head(bl)
#>   Package        Source   Target          Anchor
#> 1    base Arithmetic.Rd      Ops =S3groupGeneric
#> 2    base Arithmetic.Rd      Ops =S3groupGeneric
#> 3    base Arithmetic.Rd infinite                
#> 4    base Arithmetic.Rd   double                
#> 5    base Arithmetic.Rd   double                
#> 6    base Arithmetic.Rd  warning                
# }
```
