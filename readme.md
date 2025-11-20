# Dotfiles
>
> [!IMPORTANT]
> dotfiles directory should live at `root`. If you place it in another
> directory you need to modify the `install-mac.sh` script to instruct stow
> where it should symlink the dotfiles.

## Install GNU Stow

```Term
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Add brew to term

```Term
echo >> /Users/juan/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/juan/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

```Term
brew install stow
```

## Install symbolic links

Modify and Run in the `install-[os].sh`, e.g.:

```Term
chmod +x install.sh
./install-mac.sh
```
