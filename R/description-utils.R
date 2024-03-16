#
# Copyright (C) 2024 Packer Package.
#
# Packer Package is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.
#

#' Get package name from DESCRIPTION file.
#' @noRd
#'
#' @author Felipe Carlos, \email{efelipecarlos@gmail.com}
#'
#' @return Package name.
#'
.pkg_name <- function(description) {
  as.character(description$get("Package"))
}

#' Get package description from DESCRIPTION file.
#' @noRd
#'
#' @author Felipe Carlos, \email{efelipecarlos@gmail.com}
#'
#' @return Package description.
#'
.pkg_description <- function(description) {
  as.character(description$get("Title"))
}

#' Get package version from DESCRIPTION file.
#' @noRd
#'
#' @author Felipe Carlos, \email{efelipecarlos@gmail.com}
#'
#' @return Package version.
#'
.pkg_version <- function(description) {
  as.character(description$get("Version"))
}

#' Get package Imports dependencies from DESCRIPTION file.
#' @noRd
#'
#' @author Felipe Carlos, \email{efelipecarlos@gmail.com}
#'
#' @return Package Imports dependencies.
#'
.pkg_deps <- function(description) {
  deps <- description$get_deps()
  as.list(deps[deps$type == "Imports", ]["package"])$package
}

#' Get package Suggests dependencies from DESCRIPTION file.
#' @noRd
#'
#' @author Felipe Carlos, \email{efelipecarlos@gmail.com}
#'
#' @return Package Suggests dependencies.
#'
.pkg_optdeps <- function(description) {
  deps <- description$get_deps()
  as.list(deps[deps$type == "Suggests", ]["package"])$package
}

#' Get CRAN file name (tar.gz) of a given package.
#' @noRd
#'
#' @author Felipe Carlos, \email{efelipecarlos@gmail.com}
#'
#' @return CRAN file name of a given package
#'
.pkg_cran_file <- function(description) {
  source_file_template <- "{{name}}_{{version}}.tar.gz"

  pkg_name <- .pkg_name(description)
  pkg_version <- .pkg_version(description)

  jinjar::render(source_file_template, name = pkg_name, version = pkg_version)
}

#' Get CRAN file URL of a given package.
#' @noRd
#'
#' @author Felipe Carlos, \email{efelipecarlos@gmail.com}
#'
#' @return CRAN file name of a given package
#'
.pkg_cran_file_url <- function(description) {
  source_file_url_template <-
    "https://cran.r-project.org/src/contrib/{{file}}"

  pkg_cran_file <- .pkg_cran_file(description)

  jinjar::render(source_file_url_template, file = pkg_cran_file)
}

#' Get checksum (MD5 and SHA256) from CRAN file.
#' @noRd
#'
#' @author Felipe Carlos, \email{efelipecarlos@gmail.com}
#'
#' @return List with the CRAN file checksums (MD5 and SHA256).
#'
.pkg_cran_file_checksum <- function(description) {
  source_file <- .pkg_cran_file(description)
  source_file_url <- .pkg_cran_file_url(description)
  source_file_path <- fs::path_temp() / source_file

  utils::download.file(source_file_url, source_file_path)

  # calculating checksum
  pkg_source_file_md5 <-
    as.character(openssl::md5(source_file_path))
  pkg_source_file_sha256 <-
    as.character(openssl::sha256(source_file_path))

  fs::file_delete(source_file_path)

  list(md5 = pkg_source_file_md5, sha256 = pkg_source_file_sha256)
}
