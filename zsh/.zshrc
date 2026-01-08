# Setup Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME/.git" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Initialize completions FIRST
autoload -U compinit && compinit

# Load plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit snippet OMZP::git

# Starship prompt
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

# History
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
setopt appendhistory hist_ignore_all_dups hist_ignore_space sharehistory hist_find_no_dups

# Keybindings
bindkey -e
bindkey "^p" history-search-backward
bindkey "^n" history-search-forward
# Removed conflicting Tab binding to let fzf-tab handle it

# Completion styling
zstyle ':completion:*' menu no
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
zstyle ':fzf-tab:*' switch-group '<' '>'

# Consolidated PATH (single block, no duplicates)
export PATH="$HOME/.bin"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="$ANDROID_HOME/emulator:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="/Applications/WezTerm.app/Contents/MacOS:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$PNPM_HOME:$PATH"
export PATH="$HOME/.local/bin:$PATH"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="/Users/juan/.lmstudio/bin:$PATH"  # Keep if you use LM Studio

# Environment variables (quoted properly)
export ANDROID_HOME="$HOME/Library/Android/sdk"
export BOB_CONFIG="$HOME/.config/bob/config.json"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"
export NVM_DIR="$HOME/.nvm"
export VOLTA_HOME="$HOME/.volta"
export BUN_INSTALL="$HOME/.bun"
export PNPM_HOME="$HOME/Library/pnpm"
export PYENV_ROOT="$HOME/.pyenv"

# Editor
export REACT_EDITOR="nv"

# Aliases
alias c="clear"
alias gpush="git push -u origin \"\$(git rev-parse --abbrev-ref HEAD)\""
alias ll="eza --icons=always"
alias lla="eza --icons=always -a"
alias nv="~/.local/share/bob/v0.11.5/bin/nvim"
alias py="python3"
alias sz="source ~/.zshrc"
alias yd="yarn dev"
alias yt="yarn test"
alias ytc="yarn test:ci"
alias yc="yarn commit"
alias ycnv="yarn commit --no-verify"
alias ycp="yarn commit; git push"
alias ycpnv="yarn commit --no-verify; git push --no-verify"
alias ys="yarn start"

# Load tokens if exists
[ -f ~/.tokens ] && source ~/.tokens

# Lazy load Node.js tools (fixed unsets)
nvm() {
  unset -f nvm node npm npx pnpm yarn pnpx bun bunx 2>/dev/null || true
  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
  nvm use --lts >/dev/null 2>&1
  nvm "$@"
}

# Initialize tools AFTER PATH and compinit
if command -v pyenv &>/dev/null; then
  eval "$(pyenv init - zsh)"
fi

if command -v ngrok &>/dev/null; then
  eval "$(ngrok completion)"
fi

# Initialize fzf-tab and zoxide (AFTER compinit)
eval "$(zoxide init zsh)"
eval "$(enable-fzf-tab)"

# Bun completions (AFTER PATH includes bun)
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# rbenv (moved up from bottom)
eval "$(rbenv init - zsh)"
