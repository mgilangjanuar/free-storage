#!/usr/bin/env bash
# Adds .deb files to the apt repo in REPO_DIR and re-signs it with the gpg key APT_KEY_ID.
# Usage: APT_KEY_ID=<fingerprint> [APT_KEY_PASSPHRASE=...] update-apt-repo.sh REPO_DIR DEB...
set -euo pipefail

repo=$(cd "$1" && pwd); shift
: "${APT_KEY_ID:?set APT_KEY_ID to the signing key fingerprint}"
suite=stable
archs="all amd64 arm64 armhf i386 ppc64el riscv64 s390x"

mkdir -p "$repo/pool/main/f/free-storage"
cp "$@" "$repo/pool/main/f/free-storage/"

cd "$repo"
packages=$(apt-ftparchive packages pool)
for a in $archs; do
  d="dists/$suite/main/binary-$a"
  mkdir -p "$d"
  printf '%s\n' "$packages" >"$d/Packages"
  gzip -9nkf "$d/Packages"
done

rm -f "dists/$suite/Release" "dists/$suite/InRelease" "dists/$suite/Release.gpg"
release=$(mktemp)
apt-ftparchive \
  -o APT::FTPArchive::Release::Origin=free-storage \
  -o APT::FTPArchive::Release::Label=free-storage \
  -o APT::FTPArchive::Release::Suite=$suite \
  -o APT::FTPArchive::Release::Codename=$suite \
  -o "APT::FTPArchive::Release::Architectures=$archs" \
  -o APT::FTPArchive::Release::Components=main \
  release "dists/$suite" >"$release"
mv "$release" "dists/$suite/Release"
chmod 644 "dists/$suite/Release"

sign=(gpg --batch --yes --local-user "$APT_KEY_ID")
[ -z "${APT_KEY_PASSPHRASE:-}" ] || sign+=(--pinentry-mode loopback --passphrase "$APT_KEY_PASSPHRASE")
"${sign[@]}" --clearsign -o "dists/$suite/InRelease" "dists/$suite/Release"
"${sign[@]}" --armor --detach-sign -o "dists/$suite/Release.gpg" "dists/$suite/Release"
gpg --armor --export "$APT_KEY_ID" >key.asc
touch .nojekyll
