#!/bin/bash

if [ ! -e /opt/homebrew/bin/brew ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ ! -e /opt/homebrew/bin/stow ]; then
  brew install stow
fi

# Shell integration
if [ ! -e /opt/homebrew/bin/fzf ]; then
  brew install fzf
fi

if [ ! -e /opt/homebrew/bin/zoxide ]; then
  brew install zoxide
fi

if [ ! -e /opt/homebrew/bin/zoxide ]; then
  brew install rbenv
fi

if [ ! -e /opt/homebrew/opt/nvm/nvm.sh ]; then
  brew install nvm
fi

dotfiles=("nvim" "starship" "wezterm" "zsh")

for dotfile in "${dotfiles[@]}"; do
  echo "Processing $dotfile..."
  # Replace 'your_command' with the actual command you want to run
  # and use '$dotfile' to reference the current dotfile in the loop.
  stow "$dotfile"
done
