# free-storage

Frees regenerable disk space on macOS: project build outputs, package-manager caches, app and browser
caches, logs, Xcode leftovers and stale git worktrees. Everything it removes is rebuilt or re-downloaded
when needed.

## Install

```sh
brew tap mgilangjanuar/free-storage https://github.com/mgilangjanuar/free-storage
brew trust mgilangjanuar/free-storage
brew install free-storage
```

## Usage

```sh
free-storage --dry-run                     # preview, removes nothing
free-storage                               # low mode, the safe default
free-storage --mode balanced               # also app/browser caches, logs, Xcode, Docker
free-storage --mode aggressive --dry-run   # preview every cleanup, including the destructive ones
free-storage --mode balanced --hf          # options add to a mode
free-storage --root ~/code                 # scan one directory for projects instead of $HOME
```

| Mode | Includes |
|---|---|
| `low` (default) | Project build outputs, clean git worktrees, package-manager caches |
| `balanced` | `low` + `--app-caches --logs --xcode --docker` |
| `aggressive` | Every option below, same as `--all`. Also deletes named Docker volumes, stale `node_modules`, Hugging Face models and the Trash. |

| Option | Removes |
|---|---|
| (low) | Project build outputs: Rust `target` (next to `Cargo.toml`), `.next` / `.turbo` / `playwright-report` / `test-results` (next to `package.json`), `.pytest_cache`, `.mypy_cache`, `.ruff_cache`. Clean linked git worktrees. npm, pnpm, yarn, bun, pip, Homebrew, Go, CocoaPods, Composer, Cargo, Gradle and uv caches. |
| `--app-caches` | Third-party caches in `~/Library/Caches` (browsers such as Chrome, Firefox, Edge, Arc, Brave; Spotify; and so on), Chromium/Electron caches of apps like Slack, VS Code, Discord, Notion. With Full Disk Access: Apple Mail's opened attachments and sandboxed apps' caches. |
| `--logs` | Files in `~/Library/Logs` (including crash reports) older than `LOG_DAYS` days (default 7) |
| `--xcode` | DerivedData, iOS/watchOS/tvOS device support files, simulator caches, unavailable simulators |
| `--docker` | Unused Docker images, build cache and unused anonymous volumes (hash-named leftovers from removed containers). Named volumes are kept. Volume cleanup needs Docker Engine 23+. |
| `--docker-named-volumes` | Everything `--docker` removes, plus unused named volumes (`docker volume prune -a`). A stopped compose stack's database volumes count as unused, so this deletes that local data. |
| `--node-modules` | `node_modules` in projects with no file changed in `STALE_DAYS` days (default 30) |
| `--hf` | The Hugging Face model cache (`$HF_HOME` or `~/.cache/huggingface`) |
| `--trash` | Empties the Trash (needs Full Disk Access) |
| `--force-uv` | Cleans the uv cache even while another uv process holds its lock |
| `--all` | Every option above, same as `--mode aggressive`. Run it with `--dry-run` first. |

Each run ends with a list of large things it never deletes, for you to review: Downloads, iOS backups,
Xcode archives, the Trash, the Hugging Face cache and unused named Docker volumes.

## Safety

- App caches are skipped while their app is running, or when the cache was written in the last 10 minutes.
  Quit an app to include its cache.
- Apple system caches (`com.apple.*`) and Playwright's browser downloads are never removed.
- Git worktrees with uncommitted changes are left in place.
- When scanning `$HOME` for projects it skips `Library`, `Applications`, `OrbStack`, `Movies`, `Music`,
  `Pictures`, `Public`, `.Trash` and top-level dotfolders, and it refuses to scan `/`.
- Mail, sandboxed app caches and the Trash need Full Disk Access for your terminal
  (System Settings → Privacy & Security → Full Disk Access). Without it they are skipped, not prompted for.

Set `FREE_STORAGE_ROOT` to change the default project root.

## License

MIT
