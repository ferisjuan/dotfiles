# source
if [ -e ~/.tokens ]; then
  source ~/.tokens
fi

source <(fzf --zsh)
source $HOME/.config/zsh-plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source $HOME/.config/zsh-plugins/zsh-completions/zsh-completions.plugin.zsh
source $HOME/.config/zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoload -Uz compinit
compinit

# Alias
alias c="clear"
alias gaa="git add ."
alias gca="git commit --amend --no-edit"
alias gcanv="git commit --amend --no-edit --no-verify"
alias gma="git merge --abort"
alias gmc="git merge --continue"
alias gmm="git merge main"
alias gra="git rebase --abort"
alias grc="git rebase --continue"
alias gst="git status"
alias gsw="git switch"
alias gswm="git switch main"
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

# ENCODING
export LANG=en_US.UTF-8

# Evals
eval "$(zoxide init zsh)"
eval "$(rbenv init - zsh)"
eval "$(starship init zsh)"

# Lazy
lazynvm() {
  unset -f nvm node npm
  export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
  nvm use --lts
}

nvm() {
  lazynvm 
  nvm $@
}
 
node() {
  lazynvm
  node $@
}
 
npm() {
  lazynvm
  npm $@
}

npx() {
  lazynvm
  npx $@
}
