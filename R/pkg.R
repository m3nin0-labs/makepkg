#
# Copyright (C) 2024 Packer Package.
#
# Packer Package is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.
#

#' Create PKGBUILD for a given R Package (Based on its DESCRIPTION file).
#' @export
#'
#' @author Felipe Carlos, \email{efelipecarlos@gmail.com}
#'
#' @description This function parses a DESCRIPTION file and creates a PKGBUILD.
#'
#' @param file_description DESCRIPTION file path.
#' @param file_output PKGBUILD output file path.
#'
#' @note To learn more about the PKGBUILD file format, please, check the
#'       R package guidelines (https://wiki.archlinux.org/title/R_package_guidelines).
#'
#' @return Path where the PKGBUILD was saved.
makepkg <- function(file_description, file_output) {
  description <- desc::desc(file = file_description)

  # preparing package checksum
  pkg_checksum <- .pkg_cran_file_checksum(description)

  # rending pkgbuild file
  jinjar::render(
    .template_pkgbuild(),
    pkg_name = .pkg_name(description),
    pkg_version = .pkg_version(description),
    pkg_description = .pkg_description(description),
    pkg_deps = .pkg_deps(description),
    pkg_optdeps = .pkg_optdeps(description),
    pkg_source = .pkg_cran_file_url(description),
    pkg_source_file_md5 = pkg_checksum$md5,
    pkg_source_file_sha256 = pkg_checksum$sha256
  ) |> base::writeLines(con = base::file(file_output))

  file_output
}
