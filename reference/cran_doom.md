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
[`cran_date()`](https://repo.data.llrs.dev/reference/cran_date.md),
[`cran_snapshot()`](https://repo.data.llrs.dev/reference/cran_snapshot.md),
[`duplicated_alias()`](https://repo.data.llrs.dev/reference/duplicated_alias.md),
[`package_date()`](https://repo.data.llrs.dev/reference/package_date.md),
[`package_repos()`](https://repo.data.llrs.dev/reference/package_repos.md),
[`repos_dependencies()`](https://repo.data.llrs.dev/reference/repos_dependencies.md),
[`update_dependencies()`](https://repo.data.llrs.dev/reference/update_dependencies.md)

Other meta info from CRAN:
[`cran_actions()`](https://repo.data.llrs.dev/reference/cran_actions.md),
[`cran_alias()`](https://repo.data.llrs.dev/reference/cran_alias.md),
[`cran_archive()`](https://repo.data.llrs.dev/reference/cran_archive.md),
[`cran_comments()`](https://repo.data.llrs.dev/reference/cran_comments.md),
[`cran_links()`](https://repo.data.llrs.dev/reference/cran_links.md),
[`links()`](https://repo.data.llrs.dev/reference/links.md)

## Examples

``` r
# \donttest{
cd <- cran_doom()
#> Downloading and caching CRAN's packages database for this session.
if (length(cd) > 1L) head(cd$details)
#>              Package   Deadline   type repo n_affected
#> 1           fastshap 2026-05-20 direct CRAN          1
#> 2              BLRPM 2026-05-21 direct CRAN          1
#> 3 FuzzyNumbers.Ext.2 2026-05-21 direct CRAN          1
#> 4               HDCI 2026-05-21 direct CRAN          1
#> 5               pwr2 2026-05-21 direct CRAN          1
#> 6              reslr 2026-05-25 direct CRAN          3
# }
```
