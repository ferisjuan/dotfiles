#!/bin/bash

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed. Install Homebrew first..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

programs=("stow" "fzf" "zoxide" "eza" "rbenv" "nvm" "luaver")
for program in "${programs[@]}"; do
  echo "Looking out for $program..."
  if [ command -v "$program" ] >/dev/null 2>&1; then
    echo "$program is installed>"
    echo
  else
    brew install "$program"
  fi
done

# cask

cask_programs=("ghostty")
for cask_program in "${cask_programs[@]}"; do
  echo "Looking out for $cask_program..."
  if [ command -v "$cask_program" ] >/dev/null 2>&1; then
    echo "$cask_program is installed>"
    echo
  else
    brew install --cask "$cask_program"
  fi
done

dotfiles=("ghostty" "nvim" "starship" "wezterm" "zsh")

for dotfile in "${dotfiles[@]}"; do
  echo "Processing $dotfile..."
  # Replace 'your_command' with the actual command you want to run
  # and use '$dotfile' to reference the current dotfile in the loop.
  stow "$dotfile"
done
