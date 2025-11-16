# Estimate CRAN's date of packages

Check which CRAN dates are possible for a given packages and versions.

## Usage

``` r
cran_date(versions)

cran_session(session = sessionInfo())
```

## Arguments

- versions:

  A data.frame with the packages names and versions

- session:

  Session information.

## Value

Last installation date from CRAN.

## See also

Other utilities:
[`cran_doom()`](https://llrs.github.io/repo.data/reference/cran_doom.md),
[`cran_snapshot()`](https://llrs.github.io/repo.data/reference/cran_snapshot.md),
[`duplicated_alias()`](https://llrs.github.io/repo.data/reference/duplicated_alias.md),
[`package_date()`](https://llrs.github.io/repo.data/reference/package_date.md),
[`package_repos()`](https://llrs.github.io/repo.data/reference/package_repos.md),
[`repos_dependencies()`](https://llrs.github.io/repo.data/reference/repos_dependencies.md),
[`update_dependencies()`](https://llrs.github.io/repo.data/reference/update_dependencies.md)

## Examples

``` r
# ip <- installed.packages()
ip <- data.frame(Package = c("A3", "AER"), Version = c("1.0.0", "1.2-15"))
cran_date(ip)
#> [1] "2025-06-18 13:10:07 CEST"
cran_session()
#> [1] "2025-11-14 08:40:19 CET"
```
