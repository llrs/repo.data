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
[`cran_alias()`](https://llrs.github.io/repo.data/reference/cran_alias.md),
[`cran_archive()`](https://llrs.github.io/repo.data/reference/cran_archive.md),
[`cran_history()`](https://llrs.github.io/repo.data/reference/cran_history.md),
[`cran_links()`](https://llrs.github.io/repo.data/reference/cran_links.md),
[`links()`](https://llrs.github.io/repo.data/reference/links.md)

## Examples

``` r
# \donttest{
cc <- cran_comments()
#> Retrieving comments, this might take a bit.
#> Caching results to be faster next call in this session.
head(cc)
#>       package
#> 1          A3
#> 2 ABCExtremes
#> 3       ABCp2
#> 4       ABCp2
#> 5      ACCLMA
#> 6         ACD
#>                                                                                            comment
#> 1                           Archived on 2025-06-13 as issues were not corrected despite reminders.
#> 2     Archived on 2015-06-19 as incomplete maintainer address was not corrected despite reminders.
#> 3                     Archived on 2015-07-01 as maintainer address <duryea@dartmouth.edu> bounced.
#> 4                           Archived on 2025-01-26 as issues were not corrected despite reminders.
#> 5 Archived on 2021-02-05 as issues were not corrected despite reminders: 'xtfrm()' on data frames.
#> 6                   Archived on 2022-06-08 as check problems were not corrected despite reminders.
#>         date   action
#> 1 2025-06-13 archived
#> 2 2015-06-19 archived
#> 3 2015-07-01 archived
#> 4 2025-01-26 archived
#> 5 2021-02-05 archived
#> 6 2022-06-08 archived
# }
```
