# Tidy information about maintainers

Make more accessible information about maintainers. Extracts and makes
comparable some dates. It also provides the user name used and cleans
the names of the maintainer of extra quotes.

## Usage

``` r
cran_maintainers()
```

## Value

A data.frame with one row per package and 11 columns. The package name,
Maintainer field, user maintainer manual date, packaged date, published
date, name of maintainer used, email used, direction and domain. `NA` if
not able to collect the data from CRAN.

## Details

User is what the machine building the package reported. This might
indicate some collaboration, repackaging or simply nothing as it can be
hidden/modified. The name, email and user might help identify similar
named people (or confuse between maintainers)

## See also

The raw source of the data is:
[`CRAN_authors_db()`](https://rdrr.io/r/tools/CRANtools.html)

## Examples

``` r
maintainers <- cran_maintainers()
head(maintainers)
#>         Package                                   Maintainer        user
#> 1 AalenJohansen        Martin Bladt <martinbladt@math.ku.dk> martinbladt
#> 2       aamatch Paul Rosenbaum <rosenbaum@wharton.upenn.edu>    rosenbap
#> 3      AATtools   Sercan Kahveci <sercan.kahveci@plus.ac.at>    b1066151
#> 4        ABACUS             Mintu Nath <dr.m.nath@gmail.com>      s02mn9
#> 5   abasequence            Andrew Pilny <andy.pilny@uky.edu>   andypilny
#> 6    abbreviate        Sigbert Klinke <sigbert@hu-berlin.de>          sk
#>   maintainer_date packaged_date published_date           Name
#> 1            <NA>    2023-02-28     2023-03-01   Martin Bladt
#> 2            <NA>    2025-06-21     2025-06-24 Paul Rosenbaum
#> 3            <NA>    2024-08-16     2024-08-16 Sercan Kahveci
#> 4            <NA>    2019-09-12     2019-09-20     Mintu Nath
#> 5            <NA>    2023-07-13     2023-07-14   Andrew Pilny
#> 6      2021-12-12    2021-12-12     2021-12-14 Sigbert Klinke
#>                         email      direction            domain
#> 1      martinbladt@math.ku.dk    martinbladt        math.ku.dk
#> 2 rosenbaum@wharton.upenn.edu      rosenbaum wharton.upenn.edu
#> 3   sercan.kahveci@plus.ac.at sercan.kahveci        plus.ac.at
#> 4         dr.m.nath@gmail.com      dr.m.nath         gmail.com
#> 5          andy.pilny@uky.edu     andy.pilny           uky.edu
#> 6        sigbert@hu-berlin.de        sigbert      hu-berlin.de
```
