# source
source ~/.tokens
source <(fzf --zsh)
source $HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source ~/.config/zsh_plugins/git/git.plugin.zsh
source ~/.config/zsh_plugins/zoxide/zoxide.plugin.zsh

# alias
alias c="clear"
alias gca="git commit --amend --no-edit"
alias gcanv="git commit --amend --no-edit --no-verify"
alias gma="git merge --abort"
alias gmc="git merge --continue"
alias gmm="git merge main"
alias gra="git rebase --abort"
alias grc="git rebase --continue"
alias icat="kitten icat"
alias ks="kitty --session session.conf"
alias ll="ls"
alias lla="ls -a"
alias ls="eza --icons=always"
alias nv="~/.local/share/bob/nvim-bin/nvim"
alias py="python3"
alias tm="tmux"
alias tmk="tmux kill-session"
alias tms="tmux-sessionizer.sh"
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
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Paths
export PATH="$HOME/.bin:$PATH"
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=...:$VOLTA_HOME/bin:$YARN_HOME/bin:$PATH
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH=$JAVA_HOME/bin:$PATH

# Editor
export REACT_EDITOR="nv"

# ENCODING
export LANG=en_US.UTF-8

# evals
eval "$(zoxide init zsh)"
eval "$(rbenv init - zsh)"
eval "$(starship init zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
