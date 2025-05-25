local lualine_conf
do
    local theme_name = "silverscreen"
    local mod_color = "#b4695e"

    local theme = nil
    if pcall(require, ("lualine.themes." .. theme_name)) then
        theme = require(("lualine.themes." .. theme_name))
    end

    -- TODO: Get rid of these (`(in)?active_[fb]g`) hardcoded values in favor of the theme's
    -- values above.
    local inactive_bg = "#868383" -- lightgray
    if not (nil == theme) then
        inactive_bg = theme.inactive.a.bg
    end

    local inactive_fg = "#565454" -- gray
    if not (nil == theme) then
        inactive_fg = theme.inactive.a.fg
    end

    local active_bg = "#C2C1C1" -- white
    if not (nil == theme) then
        active_bg = theme.active.a.bg
    end

    local active_fg = "#0F0E0E" -- black
    if not (nil == theme) then
        active_fg = theme.active.a.fg
    end

    local function ro_fn()
        return ((vim.bo.readonly and "") or "")
    end

    local function only_whitespace(str)
        return string.gsub(str, ".", " ")
    end

    lualine_conf = {
        options = {
            icons_enabled = true,
            theme = theme_name,
            section_separators = { left = "", right = "" },
            component_separators = { left = "", right = "" },
            always_divide_middle = true,
            globalstatus = false,
        },
        sections = {
            lualine_a = {
                function()
                    return (vim.opt_local.paste.enabled and "Þ") or ""
                end,
                "mode",
            },
            lualine_b = {
                {
                    "buffers",
                    hide_filename_extension = false,
                    buffers_color = {
                        active = function()
                            return {
                                bg = (vim.bo.modified and mod_color) or active_bg,
                                fg = active_fg,
                                gui = "none",
                            }
                        end,
                        inactive = function()
                            return {
                                bg = inactive_bg,
                                fg = inactive_fg,
                                gui = "none",
                            }
                        end,
                    },
                    show_modified_status = true,
                    symbols = {
                        modified = " ●",
                        alternate_file = "",
                        directory = "",
                    },
                    icons_enabled = false,
                },
            },
            lualine_c = {},
            lualine_x = { "diagnostics" },
            lualine_y = { "encoding", "fileformat", "filetype", { ro_fn, color = { fg = mod_color } } },
            lualine_z = {
                { "progress", padding = { left = 1, right = 1 }, separator = " " },
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
            lualine_c = { { "filename", symbols = { modified = " ●", readonly = "  " }, padding = 2 } },
            lualine_x = {
                "ro-fn",
                { "progress", padding = { left = 1, right = 1 }, separator = " " },
                { "location", padding = { left = 1, right = 1 } },
            },
            lualine_y = {},
            lualine_z = {},
        },
        extensions = {},
    }
end

return { ["lualine_conf"] = lualine_conf }
