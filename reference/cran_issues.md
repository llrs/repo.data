# CRAN issues

Reports the notifications sent to package maintainers with the hour it
was sent and the deadline used.

## Usage

``` r
cran_issues()
```

## Value

A data.frame with 8 columns:

- ID:

  Year.number: Id of the issue.

- Package:

  Package name.

- Date:

  POSIXct object when the issue was sent.

- From:

  CRAN member that sent that notification.

- Before:

  Date by which the issue should be fixed.

- Title:

  Reason of the issue.

- Label:

  Some classification of the issue.

- Info:

  Unstructured text with some information.

## Examples

``` r
ci <- cran_issues()
#> Warning: Correcting incorrect dates on Before
if (!is.null(dim(ci))) {
  head(ci)
}
#>        ID        Package                Date From     Before Title Label Info
#> 1 2023.25           dail 2023-01-01 07:51:27  BDR 2023-01-15   Web  <NA> <NA>
#> 2 2023.26         mlpack 2023-01-01 08:19:56  BDR 2023-01-15  <NA>  <NA> <NA>
#> 3 2023.27 tokenizers.bpe 2023-01-01 10:37:02  BDR 2023-01-15  <NA>  <NA> <NA>
#> 4 2023.28         unnest 2023-01-01 10:37:02  BDR 2023-01-15  <NA>  <NA> <NA>
#> 5 2023.29         DeCAFS 2023-01-01 10:37:02  BDR 2023-01-15  <NA>  <NA> <NA>
#> 6 2023.30         udpipe 2023-01-01 10:37:02  BDR 2023-01-15  <NA>  <NA> <NA>
```
