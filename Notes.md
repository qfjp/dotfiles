# Notes on Configuring Applications

## Firefox Hotkeys

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

### Example
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
           key="w"
           command="View:PageInfo"
           modifiers="accel"
      </key>
```
