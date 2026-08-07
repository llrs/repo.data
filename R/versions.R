versions <- function() {
  tryCatch(rversions::r_versions(), warning = function(w) {
    NA
  }, error = function(e) {
    NA
  })
}
