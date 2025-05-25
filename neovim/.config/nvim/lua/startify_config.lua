local HOME = (os.getenv("HOME") or "")
local GIT_DIR = (HOME .. "/projects/github/dotfiles")

local BOOKMARK_PAIRS = {
    d = { tmux = (HOME .. "/.tmux.conf") },
    f = { neovim = (vim.fn.stdpath("config") .. "/lua/startup.lua") },
    h = { zsh = (HOME .. "/.zshrc") },
    l = { neovim = (vim.fn.stdpath("config") .. "/lua/plugins/all.lua") },
}

local skiplist =
    { "COMMIT_EDITMSG", ".git/index", "nvim/runtime/doc*", (vim.fn.stdpath("data") .. "/lazy/start/.*/doc/.*") }

local bmark_indices
do
    local ixs = {}
    for k, _ in pairs(BOOKMARK_PAIRS) do
        ixs[(1 + table.maxn(ixs))] = k
    end
    bmark_indices = ixs
end

vim.g["startify_custom_indices"] = { ";", "a", "r", "u", "v", "n", "c", "m", "n", "b", "y" }

local bookmarks = {}

for _, ix in ipairs(bmark_indices) do
    local pair = BOOKMARK_PAIRS[ix]
    for dir, bmark in pairs(pair) do
        local git_path = (GIT_DIR .. "/" .. dir .. string.gsub(bmark, HOME, ""))
        local skip_len = table.maxn(skiplist)
        local mark_len = table.maxn(bookmarks)
        bookmarks[(mark_len + 1)] = { [ix] = string.gsub(bmark, HOME, "~") }
        skiplist[(skip_len + 1)] = bmark
        skiplist[(skip_len + 2)] = git_path
    end
end

vim.cmd(
    "function! StartifyEntryFormat()\n            return 'WebDevIconsGetFileTypeSymbol(absolute_path) .\" \". entry_path'\n          endfunction"
)

vim.g["startify_files_number"] = 5
vim.g["startify_list_order"] =
    { { "Bookmarks" }, "bookmarks", { "Recent" }, "files", { "Sessions" }, "sessions", { "Cmds" }, "commands" }

vim.g["startify_skiplist"] = skiplist
vim.g["startify_bookmarks"] = bookmarks

local function shell(str)
    local lines = {}
    for line in io.popen(str):lines() do
        if line ~= "" then
            lines[(table.maxn(lines) + 1)] = line
        else
        end
    end
    return lines
end

local function replicate(str, num)
    local result = {}
    for i = 1, num do
        result[i] = str
    end
    return table.concat(result)
end

local function center(strs, cols)
    local max = 0

    local centered = {}
    for _, str in ipairs(strs) do
        if #str > max then
            max = #str
        else
        end
    end
    for ix, str in pairs(strs) do
        centered[ix] = (replicate(" ", ((cols / 2) - (max / 2))) .. str)
    end
    return centered
end

vim.g["startify_session_sort"] = 1 -- sorts bookmarks by recently used
vim.g["startify_change_to_dir"] = 0
local cmd = "~/bin/random_description.sh | cowthink -W 40 -f tux -n"

vim.g["startify_custom_header"] = center(shell(("MANWIDTH=" .. 72 .. " " .. cmd)), 80)
return nil
