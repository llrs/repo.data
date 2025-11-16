# Base R OS specific alias

Data from the R source code of OS specific man help pages. This is to
complement
[`tools::base_aliases_db()`](https://rdrr.io/r/tools/basetools.html)
which only provides links for Unix.

## Usage

``` r
os_alias
```

## Format

### `os_alias`

A matrix with 33 rows and 5 columns:

- Package:

  Package name

- os:

  OS system where this applies

- file:

  Name of the Rd file.

- Source:

  Path to the file.

- Target:

  Name of the Target
