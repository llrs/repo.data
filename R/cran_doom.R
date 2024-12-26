#' Calculate time till packages are archived
#'
#' Given the deadlines by the CRAN volunteers packages can be archived which can trigger some other packages to be archived.
#' This code calculates how much time the chain reaction will go on if maintainer don't fix/update the packages.
#'
#' Packages on Suggested: field should
#' @references Original code from: <https://github.com/schochastics/cran-doomsday/blob/main/index.qmd>
#' @author David Schoch
cran_doom <- function(which = "strong") {
    which_pkges <- match.arg(which, c("strong", "all", "most"))

    db <- tools::CRAN_package_db()

    danger <- db[!is.na(db$Deadline), c("Package", "Deadline")]
    danger$Deadline <- as.Date(danger$Deadline)
    tp <- tools::package_dependencies(danger$Package, db = db, which = which_pkges,
                                reverse = TRUE, recursive = TRUE)
    rev_dep <- names(tp)[lengths(tp) > 0]
    l <- lapply(rev_dep, function(pkg) {
        data.frame(
        Package = tp[[pkg]],
        Deadline = danger$Deadline[danger$Package == pkg] + 28L)
    })
    df2 <- do.call(rbind, l)

    l2 <- lapply(unique(df2$Package), function(pkg) {
        data.frame(Package = pkg,
                   Deadline = min(df2$Deadline[df2$Package == pkg]))
    })
    df3 <- do.call(rbind, l2)
    danger$type <- "direct"
    df3$type <- "indirect"
    out <- rbind(danger, df3)
    out <- out[out$Package %in% db$Package, ]
    rownames(out) <- NULL

    list(time_till_last = max(out$Deadline) - Sys.Date(),
         last_archived = max(out$Deadline),
         npackages = nrow(db),
         details = out)

}

#' Is a package affected by the CRAN doom.
#'
#' @seealso [cran_doom()]
cran_doom_pkg <- function(package, suggests = FALSE) {

}
