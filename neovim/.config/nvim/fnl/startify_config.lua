-- {{{ Startify
-- -------------
local git_path = os.getenv("HOME") .. "/projects/github/dotfiles/"
vim.cmd[[
    function! StartifyEntryFormat()
        return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
    endfunction
]]

vim.g.startify_files_number = 4
vim.g.startify_bookmarks = {
    vim.fn.stdpath('config') .. "/lua/plugins.lua",
    vim.fn.stdpath('config') .. "/init.fnl",
    os.getenv("HOME") .. "/.zshrc",
}
vim.g.startify_list_order = {
    {"MRU"}, "files",
    {"Bookmarks"}, "bookmarks",
    {"Sessions"}, "sessions",
    {"Cmds"}, "commands",
}
vim.g.startify_skiplist = {
    "COMMIT_EDITMSG",
    ".git/index",
    "plugged/.*/doc",
    "nvim/runtime/doc*",
    vim.fn.stdpath("config") .. "/lua/plugins.lua",
    vim.fn.stdpath("config") .. "/init.fnl",
    os.getenv("HOME") .. "/.zshrc",
    git_path .. "neovim/.config/nvim/init.fnl",
    git_path .. "neovim/.config/nvim/lua/plugins.lua",
    git_path .. "zsh/.zshrc"
}

local function cmd(str)
    local lines = {}
    local ix = 1
    for line in io.popen(str):lines() do
        if line ~= "" then
            lines[ix] = line
            ix = ix + 1
        end
    end
    return lines
end

local function replicate(str, num)
    local result = ""
    for _ = 1, num do
        result = result .. str
    end
    return result
end

local function center(strs, cols)
    local max = 0
    local centered = {}
    for _, str in ipairs(strs) do
        if #str > max then
          max = #str
        end
    end
    for ix, str in ipairs(strs) do
        centered[ix] = replicate(" ", cols / 2 - max / 2) .. str
    end
    return centered
end

vim.g.startify_custom_indices =  {"a", "d", "f", "g", "h", "l", "e", "r", "u", "i"}
vim.g.startify_custom_header = center(cmd("~/bin/random_description.sh | cowthink -W 40 -f tux -n"), 80)
-- }}}
