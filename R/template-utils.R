#
# Copyright (C) 2024 Packer Package.
#
# Packer Package is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.
#

#' Get template of the Arch Linux PKGBUILD file.
#' @noRd
#'
#' @author Felipe Carlos, \email{efelipecarlos@gmail.com}
#'
#' @return Template as String
#'
#' @note This template contains tags compatible with [jinjar::render].
#'
.template_pkgbuild <- function() {
  template <- '
_cranname={{ pkg_name }}
_cranver={{ pkg_version }}
pkgname=r-${_cranname,,}
pkgdesc="{{ pkg_description }}"
url="https://cran.r-project.org/package={{ pkg_name }}"
license=("MIT")
pkgver=${_cranver//[:-]/.}
pkgrel=1

arch=("x86_64")
depends=(
  {%- for dep in pkg_deps -%}
  r-{{  dep  }}
  {%-  endfor  -%}
)
optdepends=(
  {%- for dep in pkg_optdeps -%}
  r-{{  dep  }}
  {%-  endfor  -%}
)

source=("{{ pkg_source }}")
md5sums=("{{ pkg_source_file_md5 }}")
sha256sums=("{{ pkg_source_file_sha256 }}")

build() {
  mkdir -p build
  R CMD INSTALL "$_pkgname" -l build
}

# check() {
#     export R_LIBS="build/"
#     export _R_CHECK_FORCE_SUGGESTS_=0
#     R CMD check --no-manual "${_cranname}"
# }

package() {
  install -d "$pkgdir/usr/lib/R/library"
  cp -a --no-preserve=ownership "build/$_pkgname" "$pkgdir/usr/lib/R/library"

  install -d "$pkgdir/usr/share/licenses/$pkgname"
  ln -s "/usr/lib/R/library/$_pkgname/LICENSE" "$pkgdir/usr/share/licenses/$pkgname"
}
'

template
}
