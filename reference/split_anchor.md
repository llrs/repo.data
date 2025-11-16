# Resolve links

Converts Anchors and targets so that it can be easily understood. See
[WRE](https://cran.r-project.org/doc/manuals/r-devel/R-exts.html#Cross_002dreferences)
for extensive explanations

## Usage

``` r
split_anchor(links, count = TRUE)
```

## Arguments

- links:

  A data.frame with Package, Source, Anchor and Target.

- count:

  A logical value if links should be counted.

## Value

A data.frame with Package, Source, to_pkg, to_target, n (number of times
it happens)

## Details

There are 4 different types of links:

- `{Target}`

- `[=Target]{name}`

- `[package]{Target}`

- `[package:target]{name}` The first two can be to any package and led
  to disambiguation pages, the last two are fully resolved (package and
  alias)

## See also

[`targets2files()`](https://llrs.github.io/repo.data/reference/targets2files.md)
