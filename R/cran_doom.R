#' Calculate time till packages are archived
#'
#' Given the deadlines by the CRAN volunteers packages can be archived which can trigger some other packages to be archived.
#' This code calculates how much time the chain reaction will go on if maintainer don't fix/update the packages.
#'
#' Packages on Suggested: field should
#' @references Original code from: <https://github.com/schochastics/cran-doomsday/blob/main/index.qmd>
#' @inheritParams tools::package_dependencies
#' @param bioc Logical value if Bioconductor packages should be provided,
#' (Requires internet connection).
#' @return A list with multiple elements:
#'  - time_till_last: Time till last package is affected.
#'  - last_archived: the date of the last package that would be affected.
#'  - npackages: Numeric vector with the number of packages used.
#'  - details: A data.frame with information for each individual package:
#'  Name, date affected, affected directly, repository, times it is affected
#'  (by archival causing issues.)
#' @importFrom utils available.packages
#' @export
#' @examples
#' cd <- cran_doom()
#' head(cd$details)
cran_doom <- function(which = "strong", bioc = FALSE) {
    which_pkges <- match.arg(which, c("strong", "all", "most"))

    db <- tools::CRAN_package_db()
    db$repo <- "CRAN"
    if (isTRUE(bioc)) {
        bioc_repo <- paste0("https://bioconductor.org/packages/", bioc_version(),
                            "/bioc")
        bioc <- available.packages(repos = bioc_repo)
        bioc <- as.data.frame(bioc)
        bioc$repo <- "Bioconductor"
        columns <- intersect(colnames(bioc), colnames(db))
        db_all <- rbind(db[, columns], bioc[, columns])
    } else {
        db_all <- db
    }

    danger <- db[!is.na(db$Deadline), c("Package", "Deadline")]
    danger$Deadline <- as.Date(danger$Deadline)
    tp <- tools::package_dependencies(danger$Package, db = db_all, which = which_pkges,
                                reverse = TRUE, recursive = TRUE)
    rev_dep <- names(tp)[lengths(tp) > 0]
    # Time given by CRAN on the warnings
    # 14 for the first warning
    # 14 for the second (with dependencies added on the email)
    total_time_given <- 14L + 14L
    l <- lapply(rev_dep, function(pkg) {
        data.frame(
        Package = tp[[pkg]],
        Deadline = danger$Deadline[danger$Package == pkg] + total_time_given)
    })
    df2 <- do.call(rbind, l)
    affected <- table(df2$Package)
    multiple_affected <- names(affected)[affected > 1]

    df3 <- df2[!df2$Package %in% multiple_affected, ]
    l2 <- lapply(multiple_affected, function(pkg) {
        data.frame(Package = pkg,
                   Deadline = min(df2$Deadline[df2$Package == pkg]))
    })
    df4 <- do.call(rbind, l2)
    df5 <- rbind(df3, df4)
    danger$type <- "direct"
    df5$type <- "indirect"
    out <- rbind(danger, df5)
    out$repo <- db_all$repo[match(out$Package, db_all$Package)]

    # Count times a packages is affected by a Deadline
    out$n_affected <- 0
    out$n_affected[out$type == "direct"] <- 1
    n_affected <- affected[match(out$Package, names(affected))]
    n_affected[is.na(n_affected)] <- 0
    out$n_affected <- out$n_affected + n_affected
    out <- sort_by(out, ~list(Deadline, type, -n_affected, Package))
    rownames(out) <- NULL

    list(time_till_last = max(out$Deadline) - Sys.Date(),
         last_archived = max(out$Deadline),
         npackages = c(CRAN = nrow(db), all = nrow(db_all)),
         details = out)

}
