#!/usr/bin/env bash
# Builds dist/free-storage_<version>_all.deb from bin/free-storage. Needs dpkg-deb.
set -euo pipefail

cd "$(dirname "$0")/.."
version=$(sed -n 's/^VERSION="\(.*\)"$/\1/p' bin/free-storage)
[ -n "$version" ] || { echo "VERSION not found in bin/free-storage" >&2; exit 1; }

pkg=$(mktemp -d)
trap 'rm -rf "$pkg"' EXIT
install -Dm755 bin/free-storage "$pkg/usr/bin/free-storage"
install -d "$pkg/DEBIAN" "$pkg/usr/share/doc/free-storage"
{
  echo "Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/"
  echo "Upstream-Name: free-storage"
  echo "Source: https://github.com/mgilangjanuar/free-storage"
  echo
  echo "Files: *"
  echo "Copyright: $(sed -n 's/^Copyright (c) //p' LICENSE)"
  echo "License: MIT"
  sed -n '/^Permission/,$p' LICENSE | sed 's/^$/./; s/^/ /'
} >"$pkg/usr/share/doc/free-storage/copyright"

cat >"$pkg/usr/share/doc/free-storage/changelog" <<EOF
free-storage ($version) stable; urgency=medium

  * See https://github.com/mgilangjanuar/free-storage/releases

 -- M Gilang Januar <mgilangjanuar@gmail.com>  $(date -R)
EOF
gzip -9n "$pkg/usr/share/doc/free-storage/changelog"

cat >"$pkg/DEBIAN/control" <<EOF
Package: free-storage
Version: $version
Section: utils
Priority: optional
Architecture: all
Depends: procps, gawk | mawk
Maintainer: M Gilang Januar <mgilangjanuar@gmail.com>
Installed-Size: $(du -sk "$pkg/usr" | cut -f1)
Homepage: https://github.com/mgilangjanuar/free-storage
Description: free regenerable disk space
 Removes project build outputs, package-manager caches, app and browser
 caches, old logs, disabled snap revisions, unused Docker data and stale
 git worktrees. Everything it removes is rebuilt or re-downloaded when
 needed. Run with --dry-run to preview.
EOF

mkdir -p dist
dpkg-deb --root-owner-group --build "$pkg" "dist/free-storage_${version}_all.deb"
