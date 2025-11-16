# Report duplicated alias

Report duplicated alias

## Usage

``` r
duplicated_alias(alias)
```

## Arguments

- alias:

  The output of
  [`cran_alias()`](https://llrs.github.io/repo.data/reference/cran_alias.md)
  or
  [`base_alias()`](https://llrs.github.io/repo.data/reference/base_alias.md)

## Value

A sorted data.frame with the Target, Package and Source of the duplicate
alias.

## See also

Other utilities:
[`cran_date()`](https://llrs.github.io/repo.data/reference/cran_date.md),
[`cran_doom()`](https://llrs.github.io/repo.data/reference/cran_doom.md),
[`cran_snapshot()`](https://llrs.github.io/repo.data/reference/cran_snapshot.md),
[`package_date()`](https://llrs.github.io/repo.data/reference/package_date.md),
[`package_repos()`](https://llrs.github.io/repo.data/reference/package_repos.md),
[`repos_dependencies()`](https://llrs.github.io/repo.data/reference/repos_dependencies.md),
[`update_dependencies()`](https://llrs.github.io/repo.data/reference/update_dependencies.md)

## Examples

``` r
# Checking the overlap between to seemingly unrelated packages:
alias <- cran_alias(c("fect", "gsynth"))
if (length(alias) >= 1L) {
   dup_alias <- duplicated_alias(alias)
   head(dup_alias)
}
#>          Target Package             Source
#> 1         XXinv    fect   fect-internal.Rd
#> 2         XXinv  gsynth gsynth-internal.Rd
#> 3      Y_demean    fect   fect-internal.Rd
#> 4      Y_demean  gsynth gsynth-internal.Rd
#> 5 _gsynth_XXinv    fect   fect-internal.Rd
#> 6 _gsynth_XXinv  gsynth gsynth-internal.Rd
```
