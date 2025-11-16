# Package dates

Same as package_date but using CRAN's actions instead of public archive.

## Usage

``` r
package_date_actions(packages = ".", which = "strong")
```

## Arguments

- packages:

  Name of the package on CRAN. It accepts also local path to packages
  source directories but then the function works as if the package is
  not released yet.

- which:

  a character vector listing the types of dependencies, a subset of
  `c("Depends", "Imports", "LinkingTo", "Suggests", "Enhances")`.
  Character string `"all"` is shorthand for that vector, character
  string `"most"` for the same vector without `"Enhances"`, character
  string `"strong"` (default) for the first three elements of that
  vector.

## Details

This provides information about when a package was removed or archived
for a more accurate estimation.
