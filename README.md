# free-storage

Frees regenerable disk space on macOS and Linux: project build outputs, package-manager caches, app and
browser caches, logs, Xcode leftovers, old snap revisions and stale git worktrees. Everything it removes is
rebuilt or re-downloaded when needed.

Linux support covers Ubuntu (desktop and server, any architecture) and other Debian-based distributions;
the apt and snap steps are skipped where those tools are missing. It needs only bash, coreutils, findutils
and procps.

## Install

Debian, Ubuntu and derivatives (any architecture), with updates through `apt upgrade`:

```sh
curl -fsSL https://raw.githubusercontent.com/mgilangjanuar/free-storage/gh-pages/key.asc \
  | sudo gpg --dearmor -o /usr/share/keyrings/free-storage.gpg
echo "deb [signed-by=/usr/share/keyrings/free-storage.gpg] https://raw.githubusercontent.com/mgilangjanuar/free-storage/gh-pages stable main" \
  | sudo tee /etc/apt/sources.list.d/free-storage.list
sudo apt update && sudo apt install free-storage
```

Each [release](https://github.com/mgilangjanuar/free-storage/releases) also has the `.deb`, for
`sudo apt install ./free-storage_<version>_all.deb`.

macOS or Linux with Homebrew:

```sh
brew tap mgilangjanuar/free-storage https://github.com/mgilangjanuar/free-storage
brew trust mgilangjanuar/free-storage
brew install free-storage
```

Any other Linux:

```sh
sudo curl -fsSL https://raw.githubusercontent.com/mgilangjanuar/free-storage/main/bin/free-storage \
  -o /usr/local/bin/free-storage
sudo chmod +x /usr/local/bin/free-storage
```

## Usage

```sh
free-storage --dry-run                     # preview, removes nothing
free-storage                               # low mode, the safe default
free-storage --mode balanced               # also app/browser caches, logs, Xcode or snap, Docker
free-storage --mode aggressive --dry-run   # preview every cleanup, including the destructive ones
free-storage --mode balanced --hf          # options add to a mode
free-storage --root ~/code                 # scan one directory for projects instead of $HOME
```

| Mode | Includes |
|---|---|
| `low` (default) | Project build outputs, clean git worktrees, package-manager caches |
| `balanced` | `low` + `--app-caches --logs --docker`, plus `--xcode` on macOS or `--snap` on Linux |
| `aggressive` | Every option below, same as `--all`. Also deletes named Docker volumes, stale `node_modules`, Hugging Face models and the Trash. |

| Option | Removes |
|---|---|
| (low) | Project build outputs: Rust `target` (next to `Cargo.toml`), `.next` / `.turbo` / `playwright-report` / `test-results` (next to `package.json`), `.pytest_cache`, `.mypy_cache`, `.ruff_cache`. Clean linked git worktrees. npm, pnpm, yarn, bun, pip, Homebrew, Go, CocoaPods, Composer, Cargo, Gradle and uv caches. On Linux, downloaded apt packages (`apt-get clean`, needs root). |
| `--app-caches` | macOS: third-party caches in `~/Library/Caches` (browsers such as Chrome, Firefox, Edge, Arc, Brave; Spotify; and so on), Chromium/Electron caches of apps like Slack, VS Code, Discord, Notion. With Full Disk Access: Apple Mail's opened attachments and sandboxed apps' caches. Linux: `~/.cache` (except the Hugging Face, Playwright, uv and Poetry folders), Chromium/Electron caches in `~/.config`, snap app caches (`~/snap/*/common/.cache`) and Flatpak app caches (`~/.var/app/*/cache`). |
| `--logs` | Logs and crash reports older than `LOG_DAYS` days (default 7). macOS: `~/Library/Logs`. Linux: rotated and compressed files in `/var/log`, crash reports in `/var/crash`, and the systemd journal (`journalctl --vacuum-time`); needs root. |
| `--xcode` | macOS only. DerivedData, iOS/watchOS/tvOS device support files, simulator caches, unavailable simulators |
| `--snap` | Linux only. Disabled snap revisions, which snapd keeps for rollback; needs root |
| `--docker` | Unused Docker images, build cache and unused anonymous volumes (hash-named leftovers from removed containers). Named volumes are kept. Volume cleanup needs Docker Engine 23+. |
| `--docker-named-volumes` | Everything `--docker` removes, plus unused named volumes (`docker volume prune -a`). A stopped compose stack's database volumes count as unused, so this deletes that local data. |
| `--node-modules` | `node_modules` in projects with no file changed in `STALE_DAYS` days (default 30) |
| `--hf` | The Hugging Face model cache (`$HF_HOME` or `~/.cache/huggingface`) |
| `--trash` | Empties the Trash (`~/.Trash` on macOS, needs Full Disk Access; `~/.local/share/Trash` on Linux) |
| `--force-uv` | Cleans the uv cache even while another uv process holds its lock |
| `--all` | Every option above, same as `--mode aggressive`. Run it with `--dry-run` first. |

Each run ends with a list of large things it never deletes, for you to review: Downloads, the Trash, the
Hugging Face cache and unused named Docker volumes, plus iOS backups and Xcode archives on macOS.

## Root on Linux

Run free-storage as your own user. The steps that need root (apt cache, system logs, snap revisions) use
`sudo` only when it does not ask for a password, so a run never stops at a prompt and works from cron. To
include them, refresh sudo first or run as root:

```sh
sudo -v && free-storage --mode balanced
```

Without root they are skipped with a note. Running the whole tool with `sudo` cleans root's home instead of
yours, and it warns you when you do.

## Safety

- App caches are skipped while their app is running, or when the cache was written in the last 10 minutes.
  Quit an app to include its cache.
- Apple system caches (`com.apple.*`) and Playwright's browser downloads are never removed.
- Git worktrees with uncommitted changes are left in place.
- When scanning `$HOME` for projects it skips `Library`, `Applications`, `OrbStack`, `Movies`, `Music`,
  `Pictures`, `Public`, `Videos`, `snap`, `.Trash` and top-level dotfolders, and it refuses to scan `/`.
- On macOS, Mail, sandboxed app caches and the Trash need Full Disk Access for your terminal
  (System Settings → Privacy & Security → Full Disk Access). Without it they are skipped, not prompted for.

Set `FREE_STORAGE_ROOT` to change the default project root.

## License

MIT
