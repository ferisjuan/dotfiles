#cp -r !($HOME/.congif/tmux/plugins) $HOME/.config/tmux/!/bin/bash
cp -r `ls -A | grep -v "plugins"` $HOME/.config/tmux
cp -r $HOME/.config/nvim/lua/custom nvim/lua/custom
