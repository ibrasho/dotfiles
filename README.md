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

It contains a couple of shell files and Zsh customizations. It also installs brew and cask with a set of default applications.

## Customize

### Local Settings

The dotfiles can be easily extended to suit additional local requirements by using the following files:

#### `~/.gitconfig.local`

If the `~/.gitconfig.local` file exists, it will be automatically included after the configurations from `~/.gitconfig`, thus, allowing its content to overwrite or add to the existing git configurations.

Note: Use `~/.gitconfig.local` to store local information such as the git user credentials, e.g.:

```
[user]
	name = Ibrahim AshShohail
	email = me@ibrasho.com
	signingkey = AFC7F89347816D1EEE861BAFF58AD061F51F40FC

[commit]
  gpgsign = true

[http]
	cookiefile = /Users/ibrasho/.gitcookies

# Any GitHub repo with my username should be checked out r/w by default
# http://rentzsch.tumblr.com/post/564806957/public-but-hackable-git-submodules
[url "git@github.com:ibrasho/"]
        insteadOf = "git://github.com/ibrasho/"
```
