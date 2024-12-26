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

    req <- check_installed("igraph") && check_installed("dplyr") && check_installed("tidyr")

    if (isFALSE(req)) {
        stop("Check that igraph, dplyr and tidyr are available.")
    }

    db <- tools::CRAN_package_db()
    # db[!is.na(db$Deadline), c("Package", "Deadline")]

    select_packages <- c("Package", "Reverse depends", "Reverse imports",
                         "Reverse linking to")
    if (which_pkges == "all") {
        select_packages <- c(select_packages, "Reverse suggests", "Reverse enhances")
    } else if (which_pkges == "most") {
        select_packages <- c(select_packages, "Reverse suggests")
    }
    ntypes <- length(select_packages) - 1
    cran <- db[, select_packages]
    cran_ntype_dep <- ntypes - apply(cran[, -1], 1, function(x){sum(is.na(x))})
    message(nrow(db), " packages")
    names(cran_ntype_dep) <- db$Package
    colnames(cran)[-1] <- gsub("Reverse ", "", colnames(cran)[-1])
    message(sum(cran_ntype_dep != ntypes), " packages depending on others")

    # danger <- db$Package[!is.na(db$Deadline)]
    # tp <- tools::package_dependencies(danger, db = db, which = which_pkges,
    #                             reverse = TRUE, recursive = TRUE)
    # rev_dep <- names(tp)[lengths(tp) > 0]

    cran_db <- cran |>
        tidyr::pivot_longer(-Package, values_to = "reverse") |>
        dplyr::filter(!is.na(reverse)) |>
        dplyr::mutate(reverse = strsplit(reverse, ",")) |>
        tidyr::unnest(reverse) |>
        dplyr::mutate(reverse = trimws(reverse)) |>
        # Filter out packages not on CRAN: they follow different rules!
        dplyr::filter(reverse %in% db$Package) |>
        dplyr::select(package = Package, reverse, type = name)

    cran_graph <- igraph::graph_from_data_frame(cran_db[, 1:2]) |>
        igraph::set_edge_attr(name = "type",
                              value = cran_db$type) |>
        igraph::simplify(edge.attr.comb = list(type = function(x){
            if (any(x %in% c("suggests", "enhances"))) {
                "strong"
            } else {
                "weak"
            }
        }))
    V <- igraph::V
    E <- igraph::E
    `V<-` <- igraph::`V<-`

    message(length(danger), " packages in direct danger")
    danger <- danger[danger %in% V(cran_graph)$name]
    archive_date <- db$Deadline[match(danger, db$Package)]
    V(cran_graph)$archive_date <- NA_character_
    V(cran_graph)$archive_date[match(danger, V(cran_graph)$name)] <- archive_date

    danger_rev_pkg <- danger[cran_ntype_dep[danger] > 0]

    for (package in danger_rev_pkg) {

        v <- match(package, V(cran_graph)$name)
        dday <- as.Date(V(cran_graph)$archive_date[v])
        vbfs <- igraph::dfs(cran_graph, v, "out",
                            unreachable = FALSE, dist = FALSE)
        # Packages with reverse dependency receive a
        # first warning at 14 days (with all the reverse dependencies added.)
        # They are given 14 days more to fix it (dependencies to avoid it).
        # If not fixed they are archived (unless the dependency is on Suggests)
        v_dep <- match(V(cran_graph)$name, vbfs$order$name)
        # There is no way to know which have already received the initial warning.
        bye <- pmin(dday + 14 + 14,
                    as.Date(V(cran_graph)$archive_date[na.omit(v_dep)]),
                    na.rm = TRUE)
        V(cran_graph)$archive_date[na.omit(v_dep)] <- format(bye, "%Y-%m-%d")
    }


    archive_date <- V(cran_graph)$archive_date
    names(archive_date) <- names(V(cran_graph))
    archived <- sum(!is.na(archive_date)) / nrow(db)

    indirect_danger <- names(archive_date)[!is.na(archive_date)]
    indirect_danger <- setdiff(indirect_danger, danger)
    message(length(indirect_danger), " packages in indirect danger")
    doomday <- as.Date(max(as.Date(archive_date), na.rm = TRUE))


    df <- data.frame(package = names(archive_date)[!is.na(archive_date)],
                     arhive_date = archive_date[!is.na(archive_date)],
                     type = ifelse(names(archive_date)[!is.na(archive_date)] %in% indirect_danger, "indirect", "direct"))
    # V(cran_graph)$archive_date
    list(time_till_last = doomday - Sys.Date(),
         last_archived = doomday,
         npackages = nrow(db),
         details = df)

}

#' Is a package affected by the CRAN doom.
#'
#' @seealso [cran_doom()]
cran_doom_pkg <- function(package, suggests = FALSE) {

}
