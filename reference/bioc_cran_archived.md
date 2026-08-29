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
#> Downloading and caching packages available on Bioconductor for this session.
#> Downloading and caching CRAN's packages database for this session.
head(bca)
#>                      Package Archived n
#> 1                       IFAA     HDCI 1
#> 2 SingleMoleculeFootprinting       qs 1
#> 3                  SpiecEasi   pulsar 1
#> 4               adductomicsR smoother 1
#> 5                      iBBiG  biclust 1
#> 6                     moanin      NMI 1
```
