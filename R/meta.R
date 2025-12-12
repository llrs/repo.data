read_repo <- function(path, repo) {
  con <- tryCatch(url(sprintf("%s/%s", repo, path), open = "rb"),
    warning = function(w) {},
    error = function(e) {NULL},
    finally = {on.exit({if (!is.null(con)) close(con)}, add = TRUE)
  })

  if (is.null(con)) {
    return(NULL)
  }

  if (endsWith(path, "rds") || endsWith(path, "RDS")) {
    con <- gzcon(con)
    readRDS(con)
  } else {
    read.dcf(con)
  }

}

#' Links
#'
#' Retrieve links of repository packages to other packages' documentation.
#' @inheritParams cran_links
#' @returns A data.frame with the links on packages.  It has 4 columns: Package, Anchor, Target and Source.
#' NA if not able to collect the data from the repository.
#' @family links from CRAN
#' @family meta info from CRAN
#' @export
#' @examples
#' oldrepos <- getOption("repos")
#' setRepositories(ind = c(1, 2), addURLs = "https://cran.r-project.org")
#' head(links(c("ggplot2", "BiocCheck")))
#'
#' # Clean  up
#' options(repos = oldrepos)
links <- function(packages = NULL) {

  raw_xrefs <- lapply(getOption("repos"), read_repo, path = "src/contrib/Meta/rdxrefs.rds")
  if (is_not_data(raw_xrefs)) {
    return(NA)
  }
  check_pkg_names(packages, NA)
  env <- "full_rdxrefs"
  # Check for random packages
  current_packages <- unlist(lapply(raw_xrefs, names), use.names = FALSE)
  dups <- anyDuplicated(current_packages)
  if (length(dups) == 1L && dups[1L] != 0L) {
    warning("Packages found in multiple repositories", toString(current_packages[dups]),
    immediate. = TRUE, call. = FALSE)
  }

  omit_pkg <- check_current_pkg(packages, current_packages)

  # Keep only packages that can be processed
  packages <- setdiff(packages, omit_pkg)
  if (!is.null(packages) && !length(packages)) {
    return(NULL)
  }

  # Check if there is already data
  first_xrefs <- empty_env(env)
  if (first_xrefs) {
    xrefs <- NULL
  } else {
    xrefs <- pkg_state[[env]]
  }

  # Decide which packages are to be added to the data
  if (!is.null(packages) && !first_xrefs) {
    new_packages <- setdiff(packages, xrefs[, "Package"])
  } else if (!is.null(packages) && first_xrefs) {
    new_packages <- intersect(packages, current_packages)
  } else if (is.null(packages) && first_xrefs) {
    new_packages <- current_packages
  } else if (is.null(packages) && !first_xrefs) {
    new_packages <- setdiff(current_packages, xrefs[, "Package"])
  }

  # Add new package's data
  xrefs_list <- do.call(c, raw_xrefs)
  names(xrefs_list) <- current_packages
  if (length(new_packages)) {
    new_xrefs <- xrefs2df(xrefs_list[new_packages])
    # warnings_links(new_xrefs)
    xrefs <- rbind(xrefs, new_xrefs)
    pkg_state[[env]] <- xrefs[, c("Package", "Source", "Anchor", "Target")]
  }
  if (is.null(packages)) {
    as.data.frame(xrefs)
  } else {
    as.data.frame(xrefs[xrefs[, "Package"] %in% packages, , drop = FALSE])
  }
}

#' Links
#'
#' Retrieve links of repository packages to other packages' documentation.
#' @inheritParams cran_alias
#' @returns A data.frame with three columns: Package, Source and Target.
#' NA if not able to collect the data from the repository.
#' @family alias
#' @family meta info
#' @export
#' @examples
#' oldrepos <- getOption("repos")
#' setRepositories(ind = c(1, 2), addURLs = "https://cran.r-project.org")
#' head(alias(c("ggplot2", "BiocCheck")))
#'
#' # Clean  up
#' options(repos = oldrepos)
alias <- function(packages = NULL) {
    stopifnot("NULL or a character string" = is.null(packages) || is.character(packages))
    raw_alias <- lapply(getOption("repos"), read_repo, path = "src/contrib/Meta/aliases.rds")
    if (is_not_data(raw_alias)) {
      return(NA)
    }
    raw_alias <- save_state("aliases", raw_alias)
    check_packages(packages, NA)
    # Place to store modified data
    env <- "full_cran_aliases"
    # Check for random packages
    current_packages <- unlist(lapply(raw_alias, names), use.names = FALSE)
    dups <- anyDuplicated(current_packages)
    if (length(dups) == 1L && dups[1L] != 0L) {

      warning("Packages found in multiple repositories", toString(current_packages[dups]),
      immediate. = TRUE, call. = FALSE)
    }

    omit_pkg <- check_current_pkg(packages, current_packages)

    # Keep only packages that can be processed
    packages <- setdiff(packages, omit_pkg)
    if (!is.null(packages) && !length(packages)) {
        return(NULL)
    }

    # Check if there is already data
    first_alias <- empty_env(env)
    if (first_alias) {
        alias <- NULL
    } else {
        alias <- pkg_state[[env]]
    }

    # Decide which packages are to be added to the data
    if (!is.null(packages) && !first_alias) {
        new_packages <- setdiff(packages, alias[, "Package"])
    } else if (!is.null(packages) && first_alias) {
        new_packages <- intersect(packages, current_packages)
    } else if (is.null(packages) && first_alias) {
        new_packages <- current_packages
    } else if (is.null(packages) && !first_alias) {
        new_packages <- setdiff(current_packages, alias[, "Package"])
    }

    alias_list <- do.call(c, raw_alias)
    names(alias_list) <- current_packages
    # Add new package's data
    if (length(new_packages)) {
        new_alias <- alias2df(alias_list[new_packages])
        warnings_alias(new_alias)
        alias <- rbind(alias, new_alias)
        pkg_state[[env]] <- alias[, c("Package", "Source", "Target")]
    }
    if (is.null(packages)) {
        as.data.frame(alias)
    } else {
        as.data.frame(alias[alias[, "Package"] %in% packages, , drop = FALSE])
    }
}
