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
#> 1     a11yShiny    Jan Liebnitzky <datenlabor@bmftr.bund.de>   kammererj
#> 2           a5R              Hugh Graham <hugh@belian.earth>        hugh
#> 3       aae.pop                 Jian Yen <jdl.yen@gmail.com>        jy0f
#> 4 AalenJohansen        Martin Bladt <martinbladt@math.ku.dk> martinbladt
#> 5       aamatch Paul Rosenbaum <rosenbaum@wharton.upenn.edu>    rosenbap
#> 6      AATtools   Sercan Kahveci <sercan.kahveci@plus.ac.at>    b1066151
#>   maintainer_date packaged_date published_date           Name
#> 1            <NA>    2026-05-27     2026-05-27 Jan Liebnitzky
#> 2            <NA>    2026-07-01     2026-07-02    Hugh Graham
#> 3      2026-01-27    2026-01-27     2026-01-31       Jian Yen
#> 4            <NA>    2023-02-28     2023-03-01   Martin Bladt
#> 5            <NA>    2026-02-01     2026-02-01 Paul Rosenbaum
#> 6            <NA>    2024-08-16     2024-08-16 Sercan Kahveci
#>                         email      direction            domain
#> 1    datenlabor@bmftr.bund.de     datenlabor     bmftr.bund.de
#> 2           hugh@belian.earth           hugh      belian.earth
#> 3           jdl.yen@gmail.com        jdl.yen         gmail.com
#> 4      martinbladt@math.ku.dk    martinbladt        math.ku.dk
#> 5 rosenbaum@wharton.upenn.edu      rosenbaum wharton.upenn.edu
#> 6   sercan.kahveci@plus.ac.at sercan.kahveci        plus.ac.at
```
