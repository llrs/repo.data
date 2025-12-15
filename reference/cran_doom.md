# Calculate time till packages are archived

Given the deadlines by the CRAN volunteers packages can be archived
which can trigger some other packages to be archived. This code
calculates how much time the chain reaction will go on if maintainer
don't fix/update the packages.

## Usage

``` r
cran_doom(which = "strong", bioc = FALSE)
```

## Arguments

- which:

  a character vector listing the types of dependencies, a subset of
  `c("Depends", "Imports", "LinkingTo", "Suggests", "Enhances")`.
  Character string `"all"` is shorthand for that vector, character
  string `"most"` for the same vector without `"Enhances"`, character
  string `"strong"` (default) for the first three elements of that
  vector.

- bioc:

  Logical value if Bioconductor packages should be provided, (Requires
  internet connection).

## Value

A list with multiple elements:

- time_till_last: Time till last package is affected.

- last_archived: the date of the last package that would be affected.

- npackages: Numeric vector with the number of packages used.

- details: A data.frame with information for each individual package:
  Name, date affected, affected directly, repository, times it is
  affected (by archival causing issues.) `NA` if not able to collect the
  data from CRAN.

## Details

Packages on Suggested: field should

## References

Original code from:
<https://github.com/schochastics/cran-doomsday/blob/main/index.qmd>

## See also

The raw source of the data is:
[`tools::CRAN_package_db()`](https://rdrr.io/r/tools/CRANtools.html)

Other utilities:
[`cran_date()`](https://llrs.github.io/repo.data/reference/cran_date.md),
[`cran_snapshot()`](https://llrs.github.io/repo.data/reference/cran_snapshot.md),
[`duplicated_alias()`](https://llrs.github.io/repo.data/reference/duplicated_alias.md),
[`package_date()`](https://llrs.github.io/repo.data/reference/package_date.md),
[`package_repos()`](https://llrs.github.io/repo.data/reference/package_repos.md),
[`repos_dependencies()`](https://llrs.github.io/repo.data/reference/repos_dependencies.md),
[`update_dependencies()`](https://llrs.github.io/repo.data/reference/update_dependencies.md)

## Examples

``` r
# \donttest{
cd <- cran_doom()
#> Retrieving CRAN_db, this might take a bit.
#> Caching results to be faster next call in this session.
if (length(cd) > 1L) head(cd$details)
#>      Package   Deadline   type repo n_affected
#> 1   OpenLand 2025-12-11 direct CRAN          5
#> 2  fastmatch 2025-12-11 direct CRAN          1
#> 3    iotools 2025-12-11 direct CRAN          1
#> 4       WRSS 2025-12-15 direct CRAN          6
#> 5        DFD 2025-12-16 direct CRAN          6
#> 6 deepredeff 2025-12-16 direct CRAN          4
# }
```
