# Install a specific version of a package

Install a package from CRAN of a specific version.

## Usage

``` r
cran_version(package, version, ...)
```

## Arguments

- package:

  Name of the package present on CRAN archive.

- version:

  The version number.

- ...:

  Other arguments passed to install.packages.

## Value

Same as
[`install.packages()`](https://rdrr.io/r/utils/install.packages.html).

## Details

Uses CRAN specific API
[https://cran.r-project.org/package=%s&version=%s](https://cran.r-project.org/package=%s&version=%s)
to install a package.

## References

CRAN pages.

## Examples

``` r
if (FALSE) { # \dontrun{
install.packages("testthat", "0.7.1")
} # }
```
