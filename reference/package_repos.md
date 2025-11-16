# Package dependencies to repositories

Explore the relationships between packages and repositories.

## Usage

``` r
package_repos(packages = NULL, repos = getOption("repos"), which = "all")
```

## Arguments

- packages:

  a character vector of package names.

- repos:

  Repositories and their names are taken from `getOptions("repos")`.

- which:

  a character vector listing the types of dependencies, a subset of
  `c("Depends", "Imports", "LinkingTo", "Suggests", "Enhances")`.
  Character string `"all"` is shorthand for that vector, character
  string `"most"` for the same vector without `"Enhances"`, character
  string `"strong"` (default) for the first three elements of that
  vector.

## Value

A data.frame with one line per package and at least one column per
repository. It also has a column for Other repositories
(Additional_repositories, or missing repositories), and the total number
of dependencies and total number of repositories used. `NA` if not able
to collect the data from repositories.

## See also

Other utilities:
[`cran_date()`](https://llrs.github.io/repo.data/reference/cran_date.md),
[`cran_doom()`](https://llrs.github.io/repo.data/reference/cran_doom.md),
[`cran_snapshot()`](https://llrs.github.io/repo.data/reference/cran_snapshot.md),
[`duplicated_alias()`](https://llrs.github.io/repo.data/reference/duplicated_alias.md),
[`package_date()`](https://llrs.github.io/repo.data/reference/package_date.md),
[`repos_dependencies()`](https://llrs.github.io/repo.data/reference/repos_dependencies.md),
[`update_dependencies()`](https://llrs.github.io/repo.data/reference/update_dependencies.md)

## Examples

``` r
pr <- package_repos("experDesign")
head(pr)
#>       Package Repository @CRAN@ Other Packages_deps Repos
#> 1 experDesign     @CRAN@      6     0             6     1
```
