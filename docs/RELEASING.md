# Releasing

1. Bump `VERSION` in `bin/free-storage` and merge to `main`.
2. Tag and push: `git tag vX.Y.Z && git push origin vX.Y.Z`.
   `.github/workflows/release.yml` builds the `.deb`, attaches it to the GitHub release and publishes
   the signed apt repo to the `gh-pages` branch (served at https://mgilangjanuar.github.io/free-storage).
3. Bump `Formula/free-storage.rb` to the new tag's tarball and sha256.

## Apt signing key (one-time)

The repo is signed with a GPG key whose private half lives only in the `APT_GPG_PRIVATE_KEY` Actions
secret (and `APT_GPG_PASSPHRASE` if it has one). Users pin its public half from `key.asc`, so keep the
same key: replacing it breaks every installed machine until they re-import it.

```sh
gpg --quick-gen-key "free-storage apt repo <mgilangjanuar@gmail.com>" rsa4096 sign never
gpg --armor --export-secret-keys "free-storage apt repo" | gh secret set APT_GPG_PRIVATE_KEY
```

Back the private key up offline. GitHub Pages must serve the `gh-pages` branch root.

Build and test locally (needs `dpkg-deb`, plus `apt-utils` and `gpg` for the repo):

```sh
packaging/build-deb.sh
APT_KEY_ID=<fingerprint> packaging/update-apt-repo.sh <repo-dir> dist/*.deb
```
