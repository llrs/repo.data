# Links between help pages by page

Explore the relationship between CRAN packages and other help pages. If
the target help page is ambiguous it is omitted.

## Usage

``` r
cran_pages_links(packages = NULL)
```

## Arguments

- packages:

  A vector with packages or `NULL` for all packages.

## Value

A data.frame with 6 columns: from_pkg, from_Rd, to_pkg, to_Rd, n (Number
of links).

## See also

Other links from CRAN:
[`cran_links()`](https://llrs.github.io/repo.data/reference/cran_links.md),
[`cran_pkges_links()`](https://llrs.github.io/repo.data/reference/cran_pkges_links.md),
[`cran_targets_links()`](https://llrs.github.io/repo.data/reference/cran_targets_links.md),
[`links()`](https://llrs.github.io/repo.data/reference/links.md)

## Examples

``` r
cpl <- cran_pages_links("Matrix")
head(cpl)
#>   from_pkg                 from_Rd to_pkg               to_Rd n
#> 1   Matrix   BunchKaufman-class.Rd Matrix   expand-methods.Rd 2
#> 2   Matrix   BunchKaufman-class.Rd Matrix    solve-methods.Rd 2
#> 3   Matrix BunchKaufman-methods.Rd Matrix Cholesky-methods.Rd 2
#> 4   Matrix BunchKaufman-methods.Rd Matrix   expand-methods.Rd 2
#> 5   Matrix BunchKaufman-methods.Rd Matrix    is.na-methods.Rd 2
#> 6   Matrix BunchKaufman-methods.Rd Matrix       lu-methods.Rd 2
```
