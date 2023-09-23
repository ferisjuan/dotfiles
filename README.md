# dotfiles
## Run the following commands (asumes the `$HOME/.config` directory)
`git init --bare $HOME/.dotfiles`

`alias dotfiles='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME/.config'`

`dotfiles config --local status.showUntrackedFiles no`

`echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc`

## Usage
Create/make changes in the `$HOME/.config`
- dotfiles add file/directory
- dotfiles commit -m "commit message"
- dotfiles push

## Importing dotfiles to your setup
- Run commands above
- dotfiles switch -c [desired_branch] #OPTIONAL#
- dotfiles pull
