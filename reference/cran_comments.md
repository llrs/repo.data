# CRAN comments

CRAN volunteers document since ~2009 why they archive packages. This
function retrieves the data and prepares it for analysis, classifying
the actions taken by the team per package and date.

## Usage

``` r
cran_comments(packages = NULL)
```

## Arguments

- packages:

  A vector with packages or `NULL` for all packages.

## Value

A data.frame with four columns: package, comment, date and action. `NA`
if not able to collect the data from CRAN.

## Details

The comments are slightly edited: multiple comments for the same action
are joined together so that they can be displayed on a single line.
Actions are inferred from 7 keywords: archived, orphaned, removed,
renamed, replaced, unarchived, unorphaned.

## Note

There can be room for improvement: some comments describe two actions,
please let me know if you think this can be improved. Other actions can
be described on multiple comments/lines or out of order. Compare with
the original file in case of doubts.

## References

Original file: <https://cran.r-project.org/src/contrib/PACKAGES.in>

## See also

Other meta info from CRAN:
[`cran_actions()`](https://repo.data.llrs.dev/reference/cran_actions.md),
[`cran_alias()`](https://repo.data.llrs.dev/reference/cran_alias.md),
[`cran_archive()`](https://repo.data.llrs.dev/reference/cran_archive.md),
[`cran_doom()`](https://repo.data.llrs.dev/reference/cran_doom.md),
[`cran_links()`](https://repo.data.llrs.dev/reference/cran_links.md),
[`links()`](https://repo.data.llrs.dev/reference/links.md)

## Examples

``` r
# \donttest{
cc <- cran_comments()
#> Downloading and caching CRAN's comments for this session.
head(cc)
#> [1] NA
# }
```
