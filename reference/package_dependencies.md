# Find current installations

Despite the description minimal requirements find which versions are
required due to dependencies.

## Usage

``` r
package_dependencies(packages = ".", which = "strong")
```

## Arguments

- packages:

  Path to a file with a DESCRIPTION file or package's names from a
  repository.

- which:

  a character vector listing the types of dependencies, a subset of
  `c("Depends", "Imports", "LinkingTo", "Suggests", "Enhances")`.
  Character string `"all"` is shorthand for that vector, character
  string `"most"` for the same vector without `"Enhances"`, character
  string `"strong"` (default) for the first three elements of that
  vector.

## Value

A data.frame with the name, version required, if only one package
requires it it also show the name of the package. `NA` if not able to
collect the data from repositories.

## Note

It keeps the base packages too even if just knowing the R version
required would be enough.

## Examples

``` r
pd <- package_dependencies("ggeasy")
head(pd)
#>        Name Version    Type   Op Package
#> 1         R   4.1.0 Depends   >=    <NA>
#> 2       cli   3.4.0 Imports   >=    <NA>
#> 3 lifecycle   1.0.3 Imports   >=    <NA>
#> 4     rlang   1.1.0 Imports   >=    <NA>
#> 5     utils    <NA> Imports <NA>    <NA>
#> 6   ggplot2    <NA> Imports <NA>  ggeasy
```
