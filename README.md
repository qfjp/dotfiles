# Dot Files

## Installation Instructions

Before you get started, choose a directory where the configuration
files will be kept. I normally choose
`DOTFILES_DIR="$HOME/.github/dotfiles"`. Then, Run the following
commands in a terminal:

1. Clone the repository:
    ```bash
    git clone --recurse-submodules https://github.com/qfjp/dotfiles "$DOTFILES_DIR"
    ```

2. Change to the directory:
    ```bash
    cd "$DOTFILES_DIR"
    ```

3. Stow the config files as symlinks:
    * ZSH can glob on directories:
        ```bash
        stow -t "$HOME" *(/)
        ```
    * Otherwise, use a for loop:
        ```bash
        stow -t "$HOME" $(for file in *; do if [ -d "$file" ]; then printf "$file "; fi; done)
        ```

If everything went well, all of the dot files should be in place.

## Uninstall

```bash {data-filename="zsh"}
cd "$DOTFILES_DIR"
stow -D -t "$HOME" *(/)
# For shells that don't have advanced globbing, use:
# stow -D -t "$HOME" $(for file in * do; if [ -d $file ]; then printf "$file "; fi; done
```

## Application Specific Instructions

### Hyprland

Hyprland plugins are included as submodules, so make sure to clone
this recursively:
```bash
git clone --recurse-submodules https://github.com/qfjp/dotfiles
```

The plugins still need to be built. Patches are included for some of
the plugins, as they are not compiled against the latest version as of
this writing. To patch and build the plugins:
```bash
cd hypr/.config/hypr/plugins
make
```

### Firefox

#### Hotkeys

Firefox reserves certain hotkeys so extensions can't override them,
but it is still possible to change/disable them:

 - Find `omni.ja` in `/usr/lib/firefox/browser`
 - `omni.ja` is a standard zip file, so unzip it into the directory of
   your choice
 - Hotkey settings are in `chrome/browser/content/browser/browser.xhtml`
   * Keybindings are in `<key> </key>` tags.
   * Default bindings generally don't list the exact keys; instead
     they use functions given by the attribute `data-l10n-id`.
   * To disable a key, find the relevant `key` tag and comment it out
   * To change a key, remove the aforementioned attribute and add in a
     `key` attribute with the key you want.
   * modifiers are a comma-separated list in the `modifier` tag (no
     spaces). <kbd>Ctrl</kbd> is written as `accel`.
 - Zip everything to a new omni.ja, and replace the old one in the
   firefox directory.

#### Example
<kbd>Ctrl</kbd><kbd>i</kbd> displays the `Page Info` window. If we
want to move the current binding <kbd>Ctrl</kbd><kbd>i</kbd> to
<kbd>Ctrl</kbd><kbd>e</kbd> requires the following change in
`browser.xhtml`.

The original code:
```XML
      <key id="key_viewInfo"
           data-l10-id="page-info-shortcut"
           command="View:PageInfo"
           modifiers="accel"
      </key>
```

The modified code:
```XML
      <key id="key_viewInfo"
           key="e"
           command="View:PageInfo"
           modifiers="accel"
      </key>
```

#### Extensions
- about:debugging
- This Firefox -> <extension>.inspect
- customize css


## Other config files

Simple configuration files are maintained as github gists:

- [Firefox userChrome](https://gist.github.com/qfjp/fd50f6a0b5c0048eec7a564580874f98)

# Misc

Background image shamelessly stolen from [this sddm theme collection](https://github.com/keyitdev/sddm-astronaut-theme)
