# Find current installations

Despite the description minimal requirements find which versions are
required due to dependencies. Reports the minimal version for each
package that would be installed now.

## Usage

``` r
package_dependencies(packages = ".", which = "strong")
```

## Arguments

- packages:

  Path to a folder with a DESCRIPTION file or package's names from a
  repository. If NULL will pick all packages and their dependencies
  available.

- which:

  a character vector listing the types of dependencies, a subset of
  `c("Depends", "Imports", "LinkingTo", "Suggests", "Enhances")`.
  Character string `"all"` is shorthand for that vector, character
  string `"most"` for the same vector without `"Enhances"`, character
  string `"strong"` (default) for the first three elements of that
  vector.

## Value

A data.frame with the Package, Type, Name, Op and Version required. If
only one package requires it it also show the name of the package. `NA`
if not able to collect the data from repositories.

## Note

It keeps the base packages too even if just knowing the R version
required would be enough.

## Examples

``` r
pd <- package_dependencies("ggeasy")
head(pd)
#>        Package    Type  Name Op Version
#> 1           R6 Depends     R >=   4.1.0
#> 2 RColorBrewer Depends     R >=   4.1.0
#> 3           S7 Depends     R >=   4.1.0
#> 4           S7 Imports utils >=    <NA>
#> 5          cli Depends     R >=   4.1.0
#> 6          cli Imports utils >=    <NA>
```
