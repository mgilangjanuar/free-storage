# free-storage

Frees regenerable disk space on macOS: build outputs, package-manager caches and stale git worktrees.

## Install

```sh
brew tap mgilangjanuar/free-storage https://github.com/mgilangjanuar/free-storage
brew trust mgilangjanuar/free-storage
brew install free-storage
```

## Usage

```sh
free-storage --dry-run        # preview, removes nothing
free-storage                  # safe set, scanning $HOME
free-storage --root ~/code    # scan one directory instead
```

| Option | Removes |
|---|---|
| (default) | Rust `target` (next to `Cargo.toml`), `.next` / `.turbo` / `playwright-report` / `test-results` (next to `package.json`), `.pytest_cache`, `.mypy_cache`, `.ruff_cache`; clean linked git worktrees; npm, pnpm, Homebrew, pip, bun and uv caches |
| `--node-modules` | `node_modules` in projects with no file changed in `STALE_DAYS` days (default 30) |
| `--docker` | Unused Docker images and build cache. Volumes are never touched. |
| `--hf` | The Hugging Face model cache (`$HF_HOME` or `~/.cache/huggingface`) |
| `--force-uv` | Cleans the uv cache even while another uv process holds its lock |

Everything removed can be rebuilt or re-downloaded. Git worktrees with uncommitted changes are left in place.

When scanning `$HOME`, it skips `Library`, `Applications`, `OrbStack`, `Movies`, `Music`, `Pictures`, `Public`, `.Trash` and top-level dotfolders.

Set `FREE_STORAGE_ROOT` to change the default root.

## License

MIT
