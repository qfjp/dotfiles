# Dot Files

## Installation Instructions

Run the following in a terminal:

```bash
git clone https://gitlab.com/qfjp/dotfiles "$HOME/.config/dotfiles"
cd "$HOME/.config/dotfiles"
for x in *(/); do stow -t "$HOME" "$x"; done
```

If everything went well, all of the dot files should be in place.

## Uninstall

```bash {data-filename="zsh"}
cd "$HOME/.config/dotfiles"
stow -D -t "$HOME" *(/)
```

```bash {data-filename="bash"}
cd $HOME/.config/dotfiles
stow -t $HOME $(for file in *; do if [ -d "$file" ]; then printf "$file "; fi; done)
```

## Other config files

Simple configuration files are maintained as github gists:

- [Firefox userChrome](https://gist.github.com/qfjp/fd50f6a0b5c0048eec7a564580874f98)
