# Resolves missing targets

Resolves links that require to know available alias so solve them.

## Usage

``` r
targets2files(links, alias)
```

## Arguments

- links:

  The output of
  [`split_anchor()`](https://repo.data.llrs.dev/reference/split_anchor.md).

- alias:

  The output of
  [`alias2df()`](https://repo.data.llrs.dev/reference/alias2df.md) as
  data.frame.

## Value

A data.frame with to_pkg, to_target, from_pkg, from_Rd, n, to_Rd.
