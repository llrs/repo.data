
#'
#' It uses available information to provide the most accurate information of
#' CRAN at any given time.
#'
#' Several sources are used: CRAN's database to check packages files and versions,
#' CRAN's volunteers actions for when packages are archived or removed and
#' CRAN's comments to fill in the gaps.
#' @returns A data.frame with the information to recreate CRAN at any point before today.
#' @export
#' @seealso [cran_archive()], [cran_actions()], [cran_comments()].
#' @examples
#' cran_history
cran_history <- function() {
    archive <- cran_archive()
    actions <- cran_actions()
    comments <- cran_comments()

    archive$Date <- strftime(archive$Datetime, "%F")
    archive$Time <- strftime(archive$Datetime, "%T")
    dup_arch <- duplicated(archive[, c("Package", "Version")])
    arch <- archive[!dup_arch, ]

    # Package published twice with same version archive$Package[dup_arch]: BoundaryStats, discourseGT, lilikoi, pARccs, ScriptMapR, VSURF
    m0 <- merge(actions, arch,
                all = TRUE, by = c("Version", "Package"),
                sort = FALSE, suffixes = c("", ".archive"))
    m0$moment <- datetime2POSIXct(m0$Date, m0$Time)
    m0 <- sort_by(m0, ~Package + moment + Action)

    # Published date is later than what the archive says
    k4 <- m0$Action == "publish" & m0$Date > m0$Date.archive & !is.na(m0$Date) & !is.na(m0$Date.archive)
    ## There are some packages that were published twice
    # Do not use the date, time of the duplicated archive info
    dup_a <- duplicated(m0[, c("Package", "Version", "Action")])
    k4[dup_a] <- FALSE

    ## others the actions file Date is incorrect.
    m0$Date[k4] <- m0$Date.archive[k4]
    m0$Time[k4] <- m0$Time.archive[k4]

    # Fill the gaps from previous action if possible
    m0$moment <- datetime2POSIXct(m0$Date, m0$Time)
    m0 <- sort_by(m0, ~Package + moment + Action)

    # Use version of the previously published package
    wo_version <- which(is.na(m0$Version))
    diff_pkg <- m0$Package[wo_version] == m0$Package[(wo_version - 1)]
    k2 <- m0$Action[wo_version] == "archive" & m0$Action[(wo_version - 1)] == "publish"
    m0$Version[wo_version[diff_pkg & k2]] <- m0$Version[(wo_version[diff_pkg & k2] - 1)]

    first_package <- !duplicated(m0$Package)
    w <- sum(first_package & (m0$Action == "archive" | is.na(m0$Action)))
    warning("There are ", w, " packages starting with an archive action!")

    # Some packages have an extra archive that adds a year: I assume this was a problem with the script
    wov <- wo_version[!k2]
    p <- m0$Package[wov]
    # table(m0$Action[m0$Package %in% p] == "publish",
    #       is.na(m0$Version[m0$Package %in% p]))
    off_by_year <- abs(m0$Date[wov] - m0$Date[wov-1]) == 365L
    m0 <- m0[-na.omit(wov[off_by_year]), ]


    published <- actions[actions$Action == "publish",  , drop = FALSE]
    published$Action <- NULL
    colnames(published)[1:3] <- paste0(colnames(published)[1:3], ".Pub")

    # TODO: Add packages with archived history but no publish entry
    # m0[!is.na(m0$Date.archive), ]

    archived <- m0[m0$Action == "archive", c("Date", "Time", "User", "Version", "Package") , drop = FALSE]
    colnames(archived)[1:3] <- paste0(colnames(archived)[1:3], ".Arch")

    m <- merge(published, archived, all = TRUE, sort = FALSE)
    m$Pub.Date <- datetime2POSIXct(m$Date.Pub, m$Time.Pub)
    m$Arch.Date <- datetime2POSIXct(m$Date.Arch, m$Time.Arch)
    m <- sort_by(m, ~Package + Pub.Date + Arch.Date)

    # TODO: Find the dates of previous publish actions to use as archive date
    lapply(unique(m$package), function(i, data) {
        p <- data[data$Package == i, , drop = FALSE]
        if (nrow(p) <= 1) {
            return(p)
        }
        arch_i <- which(!is.na(p$Date.Arch))
        p$Date.Arch[-nrow(p)] <- p$Date.Pub[-1]
    }, data = m)
    m$Date.Arch
    m$Date.Pub[-1]

    removed <- actions[actions$Action == "remove",  , drop = FALSE]
    removed$Action <- NULL
    colnames(removed)[1:3] <- paste0(colnames(removed)[1:3], ".rm")
    m2 <- merge(m, removed, all = TRUE, sort = FALSE)
    m2$rm.Date <- datetime2POSIXct(m2$Date.rm, m2$Time.rm)

    # TODO: Apply the remove date to all archives

    m2
}

cran_pkges_history <- function(package) {

}
