#!/bin/bash

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed. Install Homebrew first..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

programs=("stow" "fzf" "zoxide" "rbenv" "nvm")
for program in "${programs[@]}"; do
  echo "Looking out for $program..."
  if [ command -v "$program" ] >/dev/null 2>&1; then
    echo "$program is installed>"
    echo
  else
    brew install "$program"
  fi
done

# if [ ! -e /opt/homebrew/bin/stow ]; then
#   brew install stow
# fi
#
# # Shell integration
# if [ ! -e /opt/homebrew/bin/fzf ]; then
#   brew install fzf
# fi
#
# if [ ! -e /opt/homebrew/bin/zoxide ]; then
#   brew install zoxide
# fi
#
# if [ ! -e /opt/homebrew/bin/rbenv ]; then
#   brew install rbenv
# fi
#
# if [ ! -e /opt/homebrew/opt/nvm/nvm.sh ]; then
#   brew install nvm
# fi

dotfiles=("nvim" "starship" "wezterm" "zsh")

for dotfile in "${dotfiles[@]}"; do
  echo "Processing $dotfile..."
  # Replace 'your_command' with the actual command you want to run
  # and use '$dotfile' to reference the current dotfile in the loop.
  stow "$dotfile"
done
