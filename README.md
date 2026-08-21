# Ibrahim's Dotfiles

Originally forked from https://github.com/nicksp/dotfiles

## Installation

1. Clone this repository to `~/.dotfiles`:

```bash
git clone https://github.com/ibrasho/dotfiles ~/.dotfiles
```

2. Run the setup script:

```bash
~/.dotfiles/setup.sh
```

### What setup.sh does (and needs)

The script is interactive and safe to re-run. Be aware that it will:

- Prompt before replacing each existing dotfile (backups go to a timestamped
  `~/.dotfiles_backup/<date>/` directory)
- Symlink everything in `home/` into `~`, plus `ssh/config`, the gnupg
  configs, `starship.toml` and the mise config into `~/.config`
- Clone [ibrasho/dotclaude](https://github.com/ibrasho/dotclaude) to `~/.claude`
- Install Homebrew (needs Xcode Command Line Tools and sudo) and a full
  suite of formulae and casks — including large apps like Docker Desktop and
  Microsoft Office; prune `install/brew-cask.sh` first if you don't want them
- Point iTerm2 at `iterm2/` for its preferences
- Ask for your password to change the default shell (`chsh`)

macOS system defaults are a **separate, deliberate step**:

```bash
./macos/set-defaults.sh   # review it first — it changes a lot
```

For a brand-new machine, `setup-new-machine.sh` documents the full sequence
(Xcode CLT → clone → defaults → setup). Copy/paste it section by section;
don't run it blindly.

## What's inside

- **Fast Zsh setup**: ~100ms startup. Starship prompt, cached completions,
  fzf, autosuggestions, syntax highlighting, zoxide
- **Version management**: mise for Ruby/Python/Go; PHP and Node.js are
  managed by [Herd](https://herd.laravel.com/) (nvm is lazy-loaded — it never
  taxes shell startup)
- **Git**: difftastic for syntax-aware `git diff` (use `git dd` for a
  delta-rendered classic diff), delta as pager, SSH commit signing via
  1Password, branch-agnostic aliases (`git plom` works on main *and* master)
- **Modern CLI tools**: eza, bat, fd, ripgrep, procs, lazygit, delta, direnv
- **Minimal vim**: plugin-free vimrc for quick terminal edits
- **Hardened ssh/gpg**: pinned identities (`IdentitiesOnly`), hashed
  known_hosts, no global agent forwarding

## Customize

### Local settings (never committed)

| File | Purpose |
|---|---|
| `~/.gitconfig.local` | Git identity: `user.name`, `user.email`, `signingkey` |
| `~/.zsh.local` | Machine-specific zsh config; loaded **last**, overrides everything |

`~/.gitconfig.local` template:

```ini
[user]
	name = Your Name
	email = your.email@example.com
	signingkey = YOUR_SSH_PUBLIC_KEY_OR_GPG_KEY
```

For 1Password SSH signing, enable the 1Password SSH agent and use your SSH
public key as `signingkey` (see `[gpg "ssh"]` in `.gitconfig`).

### Version management

- **PHP + Node.js**: Herd. The shell resolves Herd's default node version
  directly onto PATH; `nvm` and per-directory `.nvmrc` switching load lazily
  on first use.
- **Ruby, Python, Go**: mise, configured globally via `.mise.toml`
  (symlinked to `~/.config/mise/config.toml`). Run `mise install` after
  changing it.

### iTerm2

`setup.sh` points iTerm2's custom-preferences folder at `iterm2/`. To sync
your current settings into the repo: iTerm2 → Settings → General →
Settings tab → "Save Current Settings to Folder".

## Everyday commands

```bash
z <dir>        # zoxide: jump to a frecent directory (zi = interactive)
ctrl-r         # fzf fuzzy history search
ls / ll / lt   # eza listings, hidden files included (short / long / tree)
cat file       # bat with syntax highlighting
lazygit        # git TUI
git dd         # classic line diff (delta) instead of difftastic
git plom       # pull origin <default branch> — main or master, resolved live
```
