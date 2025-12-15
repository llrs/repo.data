# Bioconductor packages using CRAN archived packages

Checks on the 4 Bioconductor repositories which packages depend on a
archived package.

## Usage

``` r
bioc_cran_archived(which = "strong")
```

## Arguments

- which:

  a character vector listing the types of dependencies, a subset of
  `c("Depends", "Imports", "LinkingTo", "Suggests", "Enhances")`.
  Character string `"all"` is shorthand for that vector, character
  string `"most"` for the same vector without `"Enhances"`, character
  string `"strong"` (default) for the first three elements of that
  vector.

## Value

A data.frame with the name of the Bioconductor packages depending on
archived packages (on Archived column) and the number of missing
packages (n). `NA` if not able to collect the data.

## See also

For CRAN's data source:
[`tools::CRAN_package_db()`](https://rdrr.io/r/tools/CRANtools.html)

## Examples

``` r
bca <- bioc_cran_archived()
#> Retrieving bioc_available_release, this might take a bit.
#> Caching results to be faster next call in this session.
#> Retrieving CRAN_db, this might take a bit.
#> Caching results to be faster next call in this session.
head(bca)
#>                Package  Archived n
#> 1    BeadArrayUseCases beadarray 1
#> 2              CCPlotR    ggbump 1
#> 3                COTAN  gghalves 1
#> 4                 OHCA    HiCool 1
#> 5        OSCA.advanced  PCAtools 1
#> 6 beadarrayExampleData beadarray 1
```
