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

links <- function(packages = NULL) {
  
  raw_xrefs <- lapply(getOption("repos"), read_repo, path = "src/contrib/Meta/rdxrefs.rds")
  if (is_not_data(raw_xrefs)) {
    return(NA)
  }
  check_packages(packages, NA)
  env <- "full_rdxrefs"
  # Check for random packages
  current_packages <- unlist(lapply(raw_xrefs, names), use.names = FALSE)
  dups <- anyDuplicated(current_packages)
  if (length(dups) == 1L && dups[1L] != 0L) {
    
    warning("Packages found in multiple repositories", toString(current_packages[dups]), 
    immediate. = TRUE, call. = FALSE)
  }

  omit_pkg <- setdiff(packages, current_packages)
  if (length(omit_pkg)) {
    warning("Omitting packages ", toString(omit_pkg),
    ".\nMaybe they are currently not on the repositories?", immediate. = TRUE, call. = FALSE)
  }
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