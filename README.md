# Dot Files

## Installation Instructions

Run the following in a terminal:

```bash
git clone https://gitlab.com/qfjp/dotfiles "$HOME/.config/dotfiles"
cd "$HOME/.config/dotfiles"
stow -t "$HOME" *(/)
```

If everything went well, all of the dot files should be in place.

## Uninstall

```bash
cd "$HOME/.config/dotfiles"
stow -D -t "$HOME" *(/)
```
