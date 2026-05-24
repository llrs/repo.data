# Find earliest date of compatibility

Search the DESCRIPTION file for the release dates of dependencies and
return the earliest date according to CRAN's archive. This is the date
at which the package could be installed.

## Usage

``` r
package_date(packages = ".", which = "strong")
```

## Arguments

- packages:

  Path to the package folder and/or name of packages published.

- which:

  a character vector listing the types of dependencies, a subset of
  `c("Depends", "Imports", "LinkingTo", "Suggests", "Enhances")`.
  Character string `"all"` is shorthand for that vector, character
  string `"most"` for the same vector without `"Enhances"`, character
  string `"strong"` (default) for the first three elements of that
  vector.

## Value

A vector with the datetimes of the published package (or current date if
not published) and the datetime when the requirements were met. `NA` if
not able to collect the data from CRAN.

## Details

Currently this function assumes that packages only use "\>=" and not
other operators. This might change on the future if other operators are
more used.

## See also

Other utilities:
[`cran_date()`](https://repo.data.llrs.dev/reference/cran_date.md),
[`cran_doom()`](https://repo.data.llrs.dev/reference/cran_doom.md),
[`cran_snapshot()`](https://repo.data.llrs.dev/reference/cran_snapshot.md),
[`duplicated_alias()`](https://repo.data.llrs.dev/reference/duplicated_alias.md),
[`package_repos()`](https://repo.data.llrs.dev/reference/package_repos.md),
[`repos_dependencies()`](https://repo.data.llrs.dev/reference/repos_dependencies.md),
[`update_dependencies()`](https://repo.data.llrs.dev/reference/update_dependencies.md)

## Examples

``` r
package_date("ABACUS")
#>                 Published            deps_available 
#> "2019-09-20 05:40:07 UTC" "2019-04-12 00:00:00 UTC" 
package_date("paramtest")
#>                 Published            deps_available 
#> "2025-03-24 18:50:04 UTC"                        NA 
package_date("Seurat") # Dependencies on packages not on CRAN
#>                 Published            deps_available 
#> "2026-04-22 06:10:08 UTC" "2024-05-08 00:00:00 UTC" 
package_date("afmToolkit") # Dependency was removed from CRAN
#>                 Published            deps_available 
#> "2025-09-23 08:40:12 UTC" "2022-04-13 00:00:00 UTC" 
```
