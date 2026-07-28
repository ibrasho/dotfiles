# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal macOS dotfiles repo (forked from nicksp/dotfiles). It is not an
application — there is no build, no test suite, and no CI. "Working code" means
shell config that loads correctly, quickly, and in both zsh and bash.

The repo lives at `~/.dotfiles` and installs itself by **symlinking** files into
`$HOME`. Consequence for editing: changes to an already-linked file take effect
in the next shell immediately — no reinstall step. Adding a *new* file to
`home/` does require re-running `setup.sh` to create its symlink.

## Commands

```bash
./setup.sh                    # Idempotent installer. Interactive: needs a TTY
                              # (it exits early if stdin isn't a terminal) and
                              # prompts before replacing each existing dotfile.
./macos/set-defaults.sh       # macOS system defaults. Deliberately NOT called by
                              # setup.sh — separate, opt-in, changes a lot.
mise install                  # After editing .mise.toml (Ruby/Python/Go).
exec zsh                      # Reload after changes (or the `reload` alias).
```

`setup-new-machine.sh` is documentation, not a script — it says so in its own
header. Copy/paste it section by section.

### Verifying a change

There is no test runner. Use these:

```bash
shellcheck setup.sh utils.sh install/*.sh remote-setup.sh   # currently clean
shellcheck --shell=bash home/.sh_aliases                    # see note below
zsh -n home/.zshrc && bash -n home/.profile                 # syntax-only check
/usr/bin/time -p zsh -i -c exit                             # startup budget
```

- Files in `home/` have no shebang, so `shellcheck` fails them with SC2148
  unless you pass `--shell=bash` or the file carries a `# shellcheck shell=bash`
  directive (some do: `utils.sh`, `install/zsh.sh`, `setup-new-machine.sh`).
- `.shellcheckrc` disables SC1090/SC1091/SC2155 repo-wide; don't work around
  those individually.
- Startup should land around **80–130ms**. See the performance section.

## Shell config architecture

The single thing worth understanding before editing: **load order**. It is split
across five files and each split is deliberate.

```
zsh login    → home/.zprofile   PATH prepends only (Homebrew shellenv, cargo,
                                flutter, JetBrains). These MUST be here, not in
                                .zshenv: macOS /etc/zprofile runs path_helper
                                after .zshenv and would demote them.
zsh interactive → home/.zshrc   zsh options, compinit, then sources ~/.profile,
                                then tool init (mise/direnv/zoxide/starship/fzf).
bash login   → home/.bash_profile  sources ~/.profile + ~/.bash_prompt.

both shells  → home/.profile    Cross-shell hub. Sources, in order:
                                  .sh_path → .sh_exports → .sh_functions → .sh_aliases
```

Rules that follow from this:

- **`.profile` and every `.sh_*` file must stay POSIX sh** — no arrays, no
  `local`, no `[[ ]]`. They are sourced by bash too. zsh-only behavior goes
  behind `[ -n "$ZSH_VERSION" ]` (see the `help` function and the `zshrc`/
  `reload` aliases in `.sh_aliases` for the established pattern).
- Two things must stay at the **end of `.zshrc`**, in this order: sourcing
  `~/.zsh.local` (so machine-local config can override everything) and then
  `zsh-syntax-highlighting` (it requires being last).
- Plugins needing the line editor are guarded with `[[ -o zle && -t 0 ]]`
  (fzf, autosuggestions, syntax highlighting). Without it they warn in
  tty-less shells such as IDE environment probes.
- Test the *running* shell via `$ZSH_VERSION`/`$BASH_VERSION`, never `$SHELL` —
  `$SHELL` stays `zsh` inside a bash subshell.

### Startup performance is a hard constraint

`b9f6f93` cut startup from ~650ms to ~85ms and several oddities exist only to
protect that. Do not "clean these up":

- `.sh_path` hardcodes `/opt/homebrew` instead of calling `brew --prefix`
  (a fork costs 50–100ms every shell).
- nvm is **lazy-loaded**. Herd's default node goes on PATH by resolving
  `$NVM_DIR/alias/default` with pure-zsh globbing; `nvm.sh` is sourced only when
  `nvm` is called or a `.nvmrc` directory is entered. Eagerly sourcing it costs
  ~450ms.
- `compinit -C` (skips the security audit) unless the dump is >24h old. The
  `touch` after the slow path is load-bearing — plain `compinit` doesn't rewrite
  a valid dump, so without it every shell takes the slow path forever.

Anything added to `.zshrc` that forks a subprocess on every startup is a
regression. Measure before and after.

## Symlink model (`setup.sh` + `utils.sh`)

`safeSymlink` in `utils.sh` is the one primitive: it no-ops if already correctly
linked, refuses to touch directories, and otherwise prompts to move the existing
file into a timestamped `~/.dotfiles_backup/<date>/` before linking.

What gets linked where:

| Source | Target |
|---|---|
| every **file** in `home/` (dirs are skipped) | `~/` |
| `ssh/config` | `~/.ssh/config` |
| `gnupg/*` | `~/.gnupg/` |
| `starship/starship.toml` | `~/.config/starship.toml` |
| `.mise.toml` | `~/.config/mise/config.toml` |

`.mise.toml` only works via that symlink — mise reads global config solely from
`~/.config/mise/config.toml`, and the repo isn't in any project's parent path.

`setup.sh` also clones `ibrasho/dotclaude` to `~/.claude` and installs `dcg`
(destructive-command guard) *after* that clone, so its installer can register a
PreToolUse hook in `~/.claude/settings.json`. `dcg` is a safety control: its
install failure is reported loudly rather than swallowed, its installer is
pinned to a tag and downloaded before execution, and `.zshrc` warns on every
startup if the hook later disappears from settings.

Scripts sourced by `setup.sh` run under its `set -e`. That's why `install/*.sh`
append `|| echo ...` to individual `brew`/`chsh`/`cask` calls — one failing
formula must not abort the whole run.

## Machine-local files (gitignored, never committed)

| File | Purpose |
|---|---|
| `~/.gitconfig.local` | Git identity: `user.name`, `user.email`, `signingkey`. Included by `.gitconfig`; template in README. |
| `~/.zsh.local` | Machine-specific zsh; sourced last, overrides everything. |
| `.claude/settings.local.json` | Local Claude Code permissions. |

These are listed in the repo's own `.gitignore` (not just the global one)
because the global ignore is itself installed *by* this repo and doesn't exist
on a fresh clone — `git add -A` would otherwise stage credentials.

## Environment gotchas when running commands here

These apply to any shell command run in this repo's configured environment:

- **`git diff` is not a unified diff.** `diff.external = difft` routes it
  through difftastic (syntax-aware, side-by-side). For parseable output use
  `git dd` (aliased to `--no-ext-diff`) or pass `--no-ext-diff` yourself.
  `delta` is the pager, so add `--no-pager` for scripted reads.
- **GNU coreutils shadow the BSD ones** — `stat`, `sed`, etc. come from
  `coreutils/libexec/gnubin`, which `.sh_path` prepends. Flags differ. This is
  why the `fs` alias hardcodes `/usr/bin/stat`.
- **`NO_CLOBBER` is set** in interactive zsh, so `>` onto an existing file
  fails. Use `>|` to force.
- `rm` is aliased to `rm -I -v` and `mv`/`cp` to verbose variants.
- `fd` is installed but deliberately **not** aliased to `find` (incompatible CLI).

## Conventions

- **Commits**: Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`,
  `perf:`), imperative subject, body explaining *why* when non-obvious.
  Commits are signed (`commit.gpgsign` via 1Password's `op-ssh-sign`); the
  `git c`/`ca` aliases include `-s`.
- **Comments document traps, not mechanics.** Nearly every non-obvious line in
  this repo carries a comment explaining what breaks without it. Match that:
  when you add a workaround, say what fails otherwise. Preserve these comments —
  they are the repo's only regression tests.
- **Two alias layers**, keep changes in the right one: shell aliases (the `g*`
  family) in `home/.sh_aliases`; git-native aliases in `home/.gitconfig`'s
  `[alias]` section.
- Git aliases resolve the default branch live via `git default-branch` rather
  than hardcoding `main`/`master`, so they work in both.
- **Version managers are split by design**: PHP and Node.js belong to Herd,
  while Ruby/Python/Go belong to mise. Don't add `node` or `php` to
  `.mise.toml` — both are commented out there with that reason.
- Project-local binaries (`./node_modules/.bin`, `./vendor/bin`) are
  intentionally kept off PATH; use `npx` / `composer exec` / direnv.
