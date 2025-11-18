# Retrieve CRAN archive

Retrieve the archive and the current database.

## Usage

``` r
cran_archive(packages = NULL)
```

## Arguments

- packages:

  A vector with packages or `NULL` for all packages.

## Value

A data.frame with 6 columns: Package, Date (of publication), Version,
User, size and status (archived or current). It is sorted by package
name and date. `NA` if not able to collect the data from CRAN.

## Details

Some packages would get an NA in Version, if
[`package_version()`](https://rdrr.io/r/base/numeric_version.html) were
to be used with `strict = FALSE`. Packages might have been on CRAN but
could have been removed and won't show up. Depending on the data
requested and packages currently on CRAN, you might get a warning
regarding a package being both archived and current.

## See also

The raw source of the data is:
[`CRAN_archive_db()`](https://rdrr.io/r/tools/CRANtools.html),
[`CRAN_current_db()`](https://rdrr.io/r/tools/CRANtools.html). For some
dates and comments about archiving packages:
[`cran_comments()`](https://llrs.github.io/repo.data/reference/cran_comments.md).

Other meta info from CRAN:
[`cran_alias()`](https://llrs.github.io/repo.data/reference/cran_alias.md),
[`cran_comments()`](https://llrs.github.io/repo.data/reference/cran_comments.md),
[`cran_history()`](https://llrs.github.io/repo.data/reference/cran_history.md),
[`cran_links()`](https://llrs.github.io/repo.data/reference/cran_links.md),
[`links()`](https://llrs.github.io/repo.data/reference/links.md)

## Examples

``` r
if (FALSE) { # NROW(available.packages())
# \donttest{
ap <- available.packages()
if (NROW(ap)) {
    a_package <- rownames(ap)[startsWith(rownames(ap), "A")][2]
    ca <- cran_archive(a_package)
    head(ca)
}
# }
}
```
