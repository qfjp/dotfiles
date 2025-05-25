local lualine_conf
do
    local theme_name = "silverscreen"
    local mod_color = "#b4695e"
    local theme

    if pcall(require, ("lualine.themes." .. theme_name)) then
        theme = require(("lualine.themes." .. theme_name))
    else
        theme = nil
    end
    local inactive_bg
    if not (nil == theme) then
        inactive_bg = theme.inactive.a.bg
    else
        inactive_bg = nil
    end
    local inactive_fg
    if not (nil == theme) then
        inactive_fg = theme.inactive.a.fg
    else
        inactive_fg = nil
    end
    local ro_fn
    local function _4_()
        return ((vim.bo.readonly and "\238\130\162") or "")
    end
    ro_fn = _4_
    local only_whitespace
    local function _5_(str)
        return string.gsub(str, ".", " ")
    end
    only_whitespace = _5_

    local function _6_()
        return ((__fnl_global__opt_2dlocal(paste) and "\195\158") or "")
    end

    local function _7_()
        return { bg = (vim.bo.modified and mod_color), fg = nil, gui = "none" }
    end

    local function _8_()
        return { bg = inactive_bg, fg = inactive_fg, gui = "none" }
    end
    lualine_conf = {
        options = {
            icons_enabled = true,
            theme = theme_name,
            section_separators = { left = "\238\130\184", right = "\238\130\186" },
            component_separators = { left = "\238\130\185", right = "\238\130\187" },
            always_divide_middle = true,
            globalstatus = false,
        },
        sections = {
            lualine_a = { _6_, "mode" },
            lualine_b = {
                {
                    "buffers",
                    buffers_color = { active = _7_, inactive = _8_ },
                    symbols = { modified = " \226\151\143", alternate_file = "", directory = "\238\151\190" },
                    icons_enabled = false,
                },
            },
            lualine_c = {},
            lualine_x = { "diagnostics" },
            lualine_y = { "encoding", "fileformat", "filetype", { ro_fn, color = { fg = mod_color } } },
            lualine_z = {
                { "progress", padding = { left = 1, right = 1 }, separator = "\238\130\161 " },
                { "location", padding = { left = 1, right = 1 }, color = { gui = "none" } },
            },
        },
        tabline = {
            lualine_a = { "tabs" },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = { "diff" },
            lualine_z = { "branch" },
        },
        inactive_sections = {
            lualine_a = { { "mode", fmt = only_whitespace, separator = " " } },
            lualine_b = {},
            lualine_c = { { "filename", symbols = { modified = " \226\151\143", readonly = "  " }, padding = 2 } },
            lualine_x = {
                "ro-fn",
                { "progress", padding = { left = 1, right = 1 }, separator = "\238\130\161 " },
                { "location", padding = { left = 1, right = 1 } },
            },
            lualine_y = {},
            lualine_z = {},
        },
        extensions = {},
    }
end

return { ["lualine-conf"] = lualine_conf }
