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

## What does it do?

This dotfiles repository provides:

- **Modern Shell Configuration**: Optimized Zsh setup with Starship prompt
- **Version Management**: Mise for managing Node.js, Ruby, Python, Go, and more
- **Enhanced CLI Tools**: Modern replacements for traditional Unix tools
- **Development Tools**: Git configuration, Vim setup, and various utilities
- **Automated Installation**: Scripts for Homebrew packages and system configuration

### Modern CLI Tools Included

- **[mise](https://mise.jdx.dev/)** - Universal version manager (replaces nvm, rbenv, pyenv, etc.)
- **[eza](https://eza.rocks/)** - Modern `ls` replacement with colors and icons
- **[bat](https://github.com/sharkdp/bat)** - Enhanced `cat` with syntax highlighting
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** - Smarter `cd` that learns your habits
- **[fd](https://github.com/sharkdp/fd)** - Fast and user-friendly alternative to `find`
- **[ripgrep](https://github.com/BurntSushi/ripgrep)** - Extremely fast grep alternative
- **[lazygit](https://github.com/jesseduffield/lazygit)** - Terminal UI for git
- **[delta](https://github.com/dandavison/delta)** - Better git diff viewer
- **[procs](https://github.com/dalance/procs)** - Modern `ps` replacement
- **[direnv](https://direnv.net/)** - Load environment variables based on directory
- **[starship](https://starship.rs/)** - Fast, customizable shell prompt

## Customize

### Local Settings

The dotfiles can be easily extended to suit additional local requirements by using the following files:

#### `~/.gitconfig.local`

If the `~/.gitconfig.local` file exists, it will be automatically included after the configurations from `~/.gitconfig`, thus, allowing its content to overwrite or add to the existing git configurations.

**IMPORTANT**: You MUST create `~/.gitconfig.local` with your personal information. Use this template:

```ini
[user]
	name = Your Name
	email = your.email@example.com
	signingkey = YOUR_SSH_PUBLIC_KEY_OR_GPG_KEY

[http]
	cookiefile = ~/.gitcookies

# Any GitHub repo with your username should be checked out r/w by default
# http://rentzsch.tumblr.com/post/564806957/public-but-hackable-git-submodules
[url "git@github.com:YOUR_USERNAME/"]
	insteadOf = "git://github.com/YOUR_USERNAME/"
```

**For 1Password SSH Signing** (recommended):
1. Enable 1Password SSH agent in 1Password settings
2. Copy your SSH public key: `cat ~/.ssh/id_rsa.pub` (or your 1Password SSH key)
3. Use that as your `signingkey` in the template above

**For GPG Signing** (traditional):
1. Generate a GPG key: `gpg --full-generate-key`
2. Get your key ID: `gpg --list-secret-keys --keyid-format LONG`
3. Use the long key ID as your `signingkey`

#### `~/.zsh.local`

Local Zsh configuration for machine-specific settings that shouldn't be in the repository.

### Version Management

This setup uses a hybrid approach for managing language versions:

#### **Node.js & PHP** - Managed by Herd
- **Node.js**: Herd provides its own nvm installation for Node.js version management
- **PHP**: Herd manages PHP versions (8.4, 8.5, etc.)
- Herd's integrations are automatically loaded in your shell

#### **Ruby, Python, Go** - Managed by Mise

After installation, set up your language runtimes with mise:

```bash
# Install mise (already included in brew.sh)
brew install mise

# Install recommended versions from .mise.toml
mise install

# Or install specific versions globally
mise use -g ruby@latest
mise use -g python@latest
mise use -g go@latest

# List installed versions
mise list

# List available versions for a tool
mise ls-remote ruby
```

Mise automatically activates the correct versions based on:
- `.mise.toml` files in project directories
- Legacy version files (`.ruby-version`, `.python-version`, etc.)
- Global configuration at `~/.config/mise/config.toml`

**Note:** If you need Node.js outside of Herd projects, you can either:
1. Use Herd's nvm: `nvm install <version>`
2. Or enable mise for Node.js by uncommenting `node = "lts"` in `.mise.toml`

## Modern CLI Tools Usage

After installation, you'll have access to enhanced commands:

```bash
# eza replaces ls (with fallback to traditional ls)
ls          # Enhanced directory listing with icons
ll          # Long format listing
la          # List all files including hidden
lt          # Tree view
lta         # Tree view with all files

# bat replaces cat (with fallback)
cat file.txt        # Syntax-highlighted output
less file.txt       # Paginated viewing with highlighting

# zoxide replaces cd
z <partial-path>    # Jump to frequently used directories
zi                  # Interactive directory selection

# fd replaces find
fd <pattern>        # Much faster and more intuitive than find

# lazygit for git operations
lazygit             # Terminal UI for git
```
