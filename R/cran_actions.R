## What are the times between archival and unarchival?

#' Look at the CRAN actions db
#'
#' CRAN tracks movements of packages and the actions used (for example to report
#' the number of manual actions taken by the volunteers).
#' @inheritParams base_alias
#' @returns A data.frame with Date, Time, User, Action, Package and Version columns.
#' `NA` if not able to collect the data from CRAN.
#' @importFrom stats na.omit
#' @importFrom utils head
#' @keywords internal
#' @examples
#' # ca <- cran_actions()
cran_actions <- function(packages = NULL, silent = FALSE) {
    out <- cran_all_actions()
    if (is_not_data(out)) {
        return(NA)
    }
    check_pkg_names(packages, NA)
    actions <- get_package_subset("full_cran_actions", packages)
    # first_package <- !duplicated(actions$Package)

    if (isTRUE(silent)) {
        warnings_actions(actions)
    }
    actions
}

cran_all_actions <- function() {
    env <- "full_cran_actions"
    if (!empty_env(env)) {
        return(pkg_state[[env]])
    }

    actions_f <- system.file(package = "repo.data", "data", "actions.rds")
    if (!nzchar(actions_f)) {
        stop("Data not openly released, sorry can't share it (yet?)", call. = FALSE)
    }
    actions <- readRDS(actions_f)
    actions <- unique(actions)
    actions$Date <- charToDate(actions$Date, "%F")
    actions$User <- as.factor(actions$User)
    lev <- c("publish", "archive", "remove")
    if (!all(na.omit(actions$Action) %in% lev)) {
        warning("New action by CRAN: ", na.omit(setdiff(actions$Action, lev)), call. = FALSE)
    }
    actions$Action <- factor(actions$Action, levels = lev)
    actions$Package <- as.factor(actions$Package)
    actions <- sort_by(actions, ~Package + datetime2POSIXct(Date, Time) + Action)
    rownames(actions) <- NULL
    pkg_state[[env]] <- actions
    actions
}

warnings_actions <- function(actions) {
    first_package <- !duplicated(actions$Package)
    w <- sum(first_package & (actions$Action == "archive" | is.na(actions$Action)))
    if (w) {
        warning("There are ", w, " packages starting with an archive action!", call. = FALSE)
    }
    dup <- duplicated(actions[, c("Package", "Version", "Action")])
    if (any(dup)) {
        warning("There are ", sum(dup), " packages with duplicated actions for the same version.\n",
                "Explanation: This indicate a manual intervetion of the CRAN team.", call. = FALSE)
    }
}
