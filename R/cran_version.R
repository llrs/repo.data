#' Install a specific version of a package
#' 
#' Install a package from CRAN of a specific version.
#' @param package Name of the package present on CRAN archive.
#' @param version The version number.
#' @param ... Other arguments passed to install.packages. 
#' @returns Same as `install.packages()`.
#' @examples
#' \dontrun{
#' install.packages("testthat", "0.7.1")
#' }
cran_version <- function(package, version, ...) {
  valid_package_name(package)
  version <- as.package_version(version)
  url_package <- sprintf("https://cran.r-project.org/package=%s&version=%s", package, as.character(version))
  install.packages(url_package, ...)
}