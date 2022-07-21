local wezterm = require 'wezterm';
local font = "Fira Code Nerd Font"
return {
    scrollback_lines = 0,
    term = "wezterm",
    enable_tab_bar = false,
    use_fancy_tab_bar = false,
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    colors = {
        foreground = "#f8f8f2",
        background = "#272822",
        selection_fg = "#000000",
        selection_bg = "#FFFACD",
        cursor_bg = "#f8f8f2",
        ansi = {
          "#272822",
          "#f92672",
          "#a6e22e",
          "#f4bf75",
          "#66d9ef",
          "#ae81ff",
          "#a1efe4",
          "#989892",
        },
        brights = {
          "#75715e",
          "#f92672",
          "#a6e22e",
          "#f4bf75",
          "#66d9ef",
          "#ae81ff",
          "#a1efe4",
          "#f9f8f5",
        }
    },
    font = wezterm.font(font),
    font_size = 9,
    freetype_load_target = "Light",
}
