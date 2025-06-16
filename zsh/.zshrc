# Setup Zinit Home
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if not there yet
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

# Source Zinit
source "${ZINIT_HOME}/zinit.zsh"

# ice adds a temporary modifier to a next zinit command
# Load starship theme
# line 1: `starship` binary as command, from github release
# line 2: starship setup at clone(create init.zsh, completion)
# line 3: pull behavior same as clone, source init.zsh
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

# Load completions
autoload -U compinit && compinit

# Cache completions
zinit cdreplay -q

# Shell integration
[ ! -e /opt/homebrew/bin/fzf ] &&  brew install fzf
eval "$(fzf --zsh)"
[ ! -e /opt/homebrew/bin/zoxide ] && brew install zoxide
eval "$(zoxide init zsh)"
[ ! -e /opt/homebrew/bin/zoxide ] && brew install rbenv
eval "$(rbenv init - zsh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

eval "$(enable-fzf-tab)";

# Keybindings
bindkey -e
bindkey "^p" history-search-backward
bindkey "^n" history-search-forward
bindkey '\t' complete-word # "tab"

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_save_no_dups
setopt sharehistory
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' menu no
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
zstyle ':fzf-tab:*' switch-group '<' '>'

# Add in snippets
zinit snippet OMZP::git

# Alias
alias c="clear"
alias ll="ls"
alias lla="ls -a"
alias ls="eza --icons=always"
alias nv="~/.local/share/bob/nvim-bin/nvim"
alias py="python3"
alias sz="source ~/.zshrc"
alias yc="yarn commit"
alias ycnv="yarn commit --no-verify"
alias ycp="yarn commit; git push"
alias ycpnv="yarn commit --no-verify; git push --no-verify"
alias ys="yarn start"

# Homes
export ANDROID_HOME=$HOME/Library/Android/sdk
export BOB_CONFIG=$HOME/.config/bob/config.json
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"
export VOLTA_HOME="$HOME/.volta"
export YARN_HOME="$VOLTA_HOME/tools/image/yarn/1.22.21/"
export NVM_DIR="$HOME/.nvm"

# Paths
export PATH="$HOME/.bin:$PATH"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH=$JAVA_HOME/bin:$PATH
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=...:$VOLTA_HOME/bin:$YARN_HOME/bin:$PATH
export PATH=/opt/homebrew/bin:$PATH

# Editor
export REACT_EDITOR="nv"

# Tokens
[ -f ~/.tokens ] && source ~/.tokens

[ ! -e /opt/homebrew/opt/nvm/nvm.sh ] && brew install nvm
if [[ -e /opt/homebrew/opt/nvm/nvm.sh ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
  nvm use --lts
fi


