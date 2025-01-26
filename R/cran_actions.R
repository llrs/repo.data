## What are the times between archival and unarchival?

#' Look at the CRAN actions db
#'
#' CRAN tracks movements of packages and the actions used (for example to report
#' the number of manual actions taken by the volunteers).
#'
#' @return A data.frame with Date, Time, User, Action, Package and Version columns.
#' @examples
#' actions <- cran_actions()
cran_actions <- function() {

    if (!is.null(pkg_state[["cran_actions"]])) {
        return(pkg_state[["cran_actions"]])
    }

    actions_f <- system.file(package = "repo.data", "data", "actions.rds")
    actions <- readRDS(actions_f)
    actions <- unique(actions)
    actions$Date <- as.Date(actions$Date)
    actions$User <- as.factor(actions$User)
    lev <- c("publish", "archive", "remove")
    if (any(!na.omit(actions$Action) %in% lev)) {
        warning("New action by CRAN: ", na.omit(setdiff(actions$Action, lev)))
    }
    actions$Action <- factor(actions$Action, levels = lev)
    actions$Package <- as.factor(actions$Package)
    actions <- sort_by(actions, ~Package + datetime2POSIXct(Date, Time))
    rownames(actions) <- NULL
    pkg_state[["cran_actions"]] <- actions
    actions
}

cran_pkges_actions <- function(pkges) {
    get_package_subset("cran_actions", pkges)
}
