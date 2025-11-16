# Tidy dependencies

Extract the packages dependencies, name of the dependency, operator and
version for each type and package of current repositories
(`getOptions("repos")`).

## Usage

``` r
repos_dependencies(packages = NULL, which = "all")
```

## Arguments

- packages:

  a character vector of package names.

- which:

  a character vector listing the types of dependencies, a subset of
  `c("Depends", "Imports", "LinkingTo", "Suggests", "Enhances")`.
  Character string `"all"` is shorthand for that vector, character
  string `"most"` for the same vector without `"Enhances"`, character
  string `"strong"` (default) for the first three elements of that
  vector.

## Value

A data.frame with 5 columns: the name of the dependency, the operator
(op), the version it depends the type of dependency and the package.
`NA` if not able to collect the data from CRAN.

## See also

Other utilities:
[`cran_date()`](https://llrs.github.io/repo.data/reference/cran_date.md),
[`cran_doom()`](https://llrs.github.io/repo.data/reference/cran_doom.md),
[`cran_snapshot()`](https://llrs.github.io/repo.data/reference/cran_snapshot.md),
[`duplicated_alias()`](https://llrs.github.io/repo.data/reference/duplicated_alias.md),
[`package_date()`](https://llrs.github.io/repo.data/reference/package_date.md),
[`package_repos()`](https://llrs.github.io/repo.data/reference/package_repos.md),
[`update_dependencies()`](https://llrs.github.io/repo.data/reference/update_dependencies.md)

## Examples

``` r
rd <- repos_dependencies("BaseSet")
head(rd)
#>   Package     Type    Name   Op Version
#> 1 BaseSet  Depends       R   >=   4.1.0
#> 2 BaseSet  Imports   dplyr   >=   1.0.0
#> 3 BaseSet  Imports methods <NA>    <NA>
#> 4 BaseSet  Imports   rlang <NA>    <NA>
#> 5 BaseSet  Imports   utils <NA>    <NA>
#> 6 BaseSet Suggests Biobase <NA>    <NA>
```
