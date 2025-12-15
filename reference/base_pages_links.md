# Links between help pages by page

Explore the relationship between base R packages and other help pages.
If the target help page is ambiguous it is omitted.

## Usage

``` r
base_pages_links(packages = NULL)
```

## Arguments

- packages:

  A vector with packages or `NULL` for all packages.

## Value

A data.frame with 6 columns: from_pkg, from_Rd, to_pkg, to_Rd, n (Number
of links). `NA` if not able to collect the data from CRAN.

## See also

Other links from R:
[`base_links()`](https://llrs.github.io/repo.data/reference/base_links.md),
[`base_pkges_links()`](https://llrs.github.io/repo.data/reference/base_pkges_links.md),
[`base_targets_links()`](https://llrs.github.io/repo.data/reference/base_targets_links.md)

## Examples

``` r
# \donttest{
bpl <- base_pages_links()
#> Retrieving cran_aliases, this might take a bit.
#> Caching results to be faster next call in this session.
#> Warning: Package has targets not present in a OS:
#> ‘sfsmisc’
#> Warning: Some pages point to different places according to the OS.
#> Warning: Some links are distinct depending on the OS.
head(bpl)
#>   from_pkg       from_Rd to_pkg       to_Rd n
#> 1     base Arithmetic.Rd   base  matmult.Rd 1
#> 2     base Arithmetic.Rd   base zMachine.Rd 1
#> 3     base Arithmetic.Rd   base       NA.Rd 1
#> 4     base Arithmetic.Rd   base  Special.Rd 1
#> 5     base Arithmetic.Rd   base   Syntax.Rd 1
#> 6     base Arithmetic.Rd   base   double.Rd 1
# }
```
