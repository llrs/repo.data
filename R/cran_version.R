#' Install a specific version of a package
#'
#' Install a package from CRAN of a specific version.
#'
#' Uses CRAN specific API <https://cran.r-project.org/package=%s&version=%s> to install a package.
#' @param package Name of the package present on CRAN archive.
#' @param version The version number.
#' @param ... Other arguments passed to install.packages.
#' @returns Same as `install.packages()`.
#' @references CRAN pages.
#' @importFrom utils install.packages
#' @export
#' @examples
#' \dontrun{
#' cran_version("repo.data", "0.1.5", lib = tempdir())
#' }
cran_version <- function(package, version, ...) {
  valid_package_name(package)
  version <- as.package_version(version)
  url_package <- sprintf("https://cran.r-project.org/package=%s&version=%s", package, as.character(version))
  install.packages(pkgs = url_package, repos = NULL, ...)
}
