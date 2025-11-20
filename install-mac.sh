#!/bin/bash
programs=("stow" "fzf" "zoxide" "eza" "rbenv" "nvm" "luaver" "watchman" "xcodesorg/made/xcodes" "docker" "zsh" "bob")
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
cask_programs=("ghostty" "brave-browser" "dbeaver-community" "zulu@17" "microsoft-teams" "postman" "protonvpn" "obsidian" "zoom" "omnidisksweeper" "ngrok")
for cask_program in "${cask_programs[@]}"; do
  echo "Looking out for $cask_program..."
  if [ command -v "$cask_program" ] >/dev/null 2>&1; then
    echo "$cask_program is installed>"
    echo
  else
    brew install --cask "$cask_program"
  fi
done

dotfiles=("ghostty" "nvim" "starship" "zsh")

for dotfile in "${dotfiles[@]}"; do
  echo "Processing $dotfile..."
  # Replace 'your_command' with the actual command you want to run
  # and use '$dotfile' to reference the current dotfile in the loop.
  stow -S "$dotfile"
done
