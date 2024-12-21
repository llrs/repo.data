#' Calculate time till packages are archived
#'
#' Given the deadlines by the CRAN volunteers packages can be archived which can trigger some other packages to be archived.
#' This code calculates how much time the chain reaction will go on if maintainer don't fix/update the packages.
#' @references Original code from: <https://github.com/schochastics/cran-doomsday/blob/main/index.qmd>
#' @author David Schoch
cran_doom <- function() {
    # https://github.com/schochastics/cran-doomsday/blob/main/index.qmd
}

#' Is a package affected by the CRAN doom.
#'
#' @seealso [cran_doom()]
cran_doom_pkg <- function(package) {

}
