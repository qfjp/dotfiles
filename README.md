# Dot Files

## Installation Instructions

Before you get started, choose a directory where the configuration
files will be kept. I normally choose
`DOTFILES_DIR=$HOME/.github/dotfiles"``. Then, Run the following
commands in a terminal:

1. Clone the repository:
    ```bash
    git clone https://gitlab.com/qfjp/dotfiles "$DOTFILES_DIR"`
    ```

2. Change to the directory:
    ```bash
    cd "$DOTFILES_DIR"
    ```

3. Stow the config files as symlinks:
    * ZSH can glob on directories:
        ```bash
        for x in *(/); do stow -t "$HOME" "$x"; done
        ```
    * Otherwise, use a for loop:
        ```bash
        stow -t "$HOME" $(for file in *; do if [ -d "$file" ]; then printf "$file "; fi; done)
        ```

If everything went well, all of the dot files should be in place.

## Uninstall

```bash {data-filename="zsh"}
cd "DOTFILES_DIR"
stow -D -t "$HOME" *(/)
# For shells that don't have advanced globbing, use:
# stow -D -t "$HOME" $(for file in * do; if [ -d $file ]; then printf "$file "; fi; done
```


## Other config files

Simple configuration files are maintained as github gists:

- [Firefox userChrome](https://gist.github.com/qfjp/fd50f6a0b5c0048eec7a564580874f98)
