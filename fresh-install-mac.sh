#!/bin/bash
# Install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# set github config
git config --global user.name "Juan Feris"
git config --global user.email "feris.juan@gmail.com"

# install rust and cargo
if [ command -v cargo ] >/dev/null 2>&1; then
  echo "Rust and corgo are installed"
else
  curl https://sh.rustup.rs -sSf | sh
  source "$HOME/.cargo/env"
fi

# install tree-sitter-cli
if [ command -v tree-sitter ] >/dev/null 2>&1; then
  echo "tree-sitter-cli is installed"
else
  cargo install --locked tree-sitter-cli
fi

if [ command -v bash ] >/dev/null 2>&1; then
  echo "Homebrew is installed"
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo >>/Users/juan/.zprofile
  echo "eval \"$(/opt/homebrew/bin/brew shellenv)\"" >>/Users/juan/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
programs=("stow" "fzf" "zoxide" "eza" "rbenv" "nvm" "luaver" "watchman" "xcodesorg/made/xcodes" "docker" "zsh" "bob" "ngrok" "luarocks" "rg" "luajit" "fd" "imagemagick" "ghostscript" "gs" "mermaid-cli" "python" "tectonic" "pdfly" "tree-sitter" "tree-sitter-cli" "viu" "chafa" "jstkdng/programs/ueberzugpp")
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
cask_programs=("ghostty" "font-fira-code" "brave-browser" "dbeaver-community" "zulu@17" "microsoft-teams" "postman" "protonvpn" "obsidian" "zoom" "omnidisksweeper")
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
