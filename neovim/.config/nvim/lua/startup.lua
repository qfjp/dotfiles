if pcall(require, "transparent") then
    local transparent = require("transparent")
    transparent.setup({ exclude_groups = { "Visual" } })
    transparent.clear_prefix("GitSigns")
    transparent.clear_prefix("Visual")
else
end

if pcall(require, "nvim-treesitter") then
    require("treesitter_config")
else
end

if pcall(require, "telescope") then
    local telescope = require("telescope")
    local themes = require("telescope.themes")
    telescope.setup({
        extensions = {
            opts = {},
            picker_list = {},
            excluded_pickers = {},
            docker = {},
            undo = {},
            lsp_handlers = { code_action = { telescope = themes.get_dropdown({}) } },
        },
    })

    telescope.load_extension("fzy_native")
    telescope.load_extension("jj")
    telescope.load_extension("foldmarkers")
    telescope.load_extension("texsuite")
    telescope.load_extension("docker")
    telescope.load_extension("undo")
    telescope.load_extension("ports")
    telescope.load_extension("conventional_commits")
    telescope.load_extension("lsp_handlers")
    telescope.load_extension("ht")

    telescope.load_extension("picker_list")
else
end

if pcall(require, "inc_rename") then
    require("inc_rename").setup({})
else
end

require("startify_config")
require("goyo_config")

local or_7_ = vim.g.goneovim
if not or_7_ then
    or_7_ = vim.g.neovide
end
if or_7_ then
    vim.api.nvim_create_augroup("Gui", { clear = true })
    do
        local _ = {}
    end
else
end

vim.g["mapleader"] = " "
vim.g["maplocalleader"] = "\\"

vim.opt["showmode"] = false
vim.opt["laststatus"] = 2
vim.opt["cmdheight"] = 2
vim.opt["cursorline"] = true
vim.opt["colorcolumn"] = "71"
vim.opt["background"] = "dark"

vim.cmd(("source" .. (vim.fn.stdpath("config") .. "/greek.vim")))

vim.opt["hlsearch"] = true
vim.opt["incsearch"] = true
vim.opt["wrapscan"] = false
vim.opt["ignorecase"] = true
vim.opt["smartcase"] = true

local function _9_(blinktime)
    do
        vim.cmd("highlight! link SearchBlink IncSearch")
    end
    local search_text = vim.api.nvim_eval("@/")
    local target_pat = ("\\c\\%#" .. search_text)
    local ring = vim.fn.matchadd("SearchBlink", target_pat, 101)
    local sleep_str = string.format("%sm", (blinktime * 200))
    local call_str = string.format("matchdelete(%s)", ring)
    return vim.cmd(("redraw | sleep " .. sleep_str .. " | call " .. call_str))
end
HlNext = _9_

vim.opt["autoindent"] = true
vim.opt["smarttab"] = true
vim.opt["expandtab"] = true
vim.opt["tabstop"] = 4
vim.opt["shiftwidth"] = 4
vim.opt["textwidth"] = 70

vim.opt["linebreak"] = true
vim.opt["breakindent"] = true
vim.opt["showbreak"] = "-\226\134\146"
vim.g["html_indent_inctags"] = "head,html,body,p,head,table,tbody,div,script"

vim.g["html_indent_script1"] = "inc"
vim.g["html_indent_style1"] = "inc"

vim.opt["wrap"] = true
vim.opt["linebreak"] = true

vim.opt["undofile"] = true
vim.opt["undodir"] = (os.getenv("HOME") .. "/.local/share/vim-backup")
vim.opt["scrolloff"] = 5
vim.opt["autochdir"] = true

vim.opt["history"] = 1000
vim.opt["undolevels"] = 1000

vim.opt["mouse"] = ""

vim.opt["backspace"] = { "indent", "eol", "start" }
vim.opt.cpoptions:append("$")

vim.opt["ruler"] = true
vim.opt["title"] = true
vim.opt["autoread"] = true
vim.opt["wildmenu"] = true

vim.opt["hidden"] = true
vim.opt["formatoptions"] = "coq2"

vim.api.nvim_create_augroup("QFixToggle", { clear = true })
do
    local _ = {
        vim.api.nvim_create_autocmd("BufWinEnter", {
            command = 'let g:qfix_win=bufnr("$")|set nolist|set colorcolumn=0',
            group = "QFixToggle",
            pattern = "quickfix",
        }),
        vim.api.nvim_create_autocmd("BufWinLeave", {
            command = 'if exists("g:qfix_win") && g:qfix_win == expand("<abuf>")|unlet! g:qfix_win|endif',
            group = "QFixToggle",
            pattern = "quickfix",
        }),
    }
end

local function ScratchBuf()
    local scratchname = "scratch"

    local scratchbuf = vim.fn.bufnr(scratchname)
    if -1 == scratchbuf then
        scratchbuf = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_buf_set_name(scratchbuf, scratchname)
    else
    end
    vim.api.nvim_win_set_buf(0, scratchbuf)
    vim.opt_local.buftype = "nofile"
    vim.opt_local.bufhidden = "hide"
    vim.opt_local.swapfile = false

    return nil
end

vim.api.nvim_create_user_command("Scratch", ScratchBuf, {})

vim.opt["showmatch"] = true
vim.opt["list"] = true
vim.opt["conceallevel"] = 0

local function MatchHighIp(str)
    local subnet = "192.168.1."

    return (
        string.match(str, (subnet .. "[4-9]"))
        or string.match(str, (subnet .. "[1-9][0-9]"))
        or string.match(str, (subnet .. "[1-2][0-9][0-9]"))
    )
end

if not (("linux" == os.getenv("TERM")) or ("linux" == os.getenv("OLD_TERM"))) then
    vim.opt["termguicolors"] = true
else
end

vim.opt["listchars"] = "tab:\226\150\149\226\150\145,trail:\226\150\146,extends:>,precedes:<"

vim.env.NVIM_LISTEN_ADDRESS = vim.v.servername

local function TermOptions()
    vim.opt["filetype"] = "terminal"

    vim.b["terminal_color_0"] = "#1A1919"
    vim.b["terminal_color_8"] = "#75715e"

    vim.b["terminal_color_1"] = "#f92672"
    vim.b["terminal_color_9"] = "#f92672"

    vim.b["terminal_color_2"] = "#a6e22e"
    vim.b["terminal_color_10"] = "#a6e22e"

    vim.b["terminal_color_3"] = "#f4bf75"
    vim.b["terminal_color_11"] = "#f4bf75"

    vim.b["terminal_color_4"] = "#66d9ef"
    vim.b["terminal_color_12"] = "#66d9ef"

    vim.b["terminal_color_5"] = "#ae81ff"
    vim.b["terminal_color_13"] = "#ae81ff"

    vim.b["terminal_color_6"] = "#a1efe4"
    vim.b["terminal_color_14"] = "#a1efe4"

    vim.b["terminal_color_7"] = "#989892"
    vim.b["terminal_color_15"] = "#f9f8f5"
    return nil
end

vim.api.nvim_create_augroup("Terminal", { clear = true })
do
    local _ = { vim.api.nvim_create_autocmd("TermOpen", { callback = TermOptions, group = "Terminal", pattern = "*" }) }
end

vim.opt["foldcolumn"] = "0"
vim.opt["foldlevelstart"] = 99

vim.opt.viewoptions:remove("options")

local function HaskellToolsFn()
    local ht = require("haskell-tools")
    local bufnr = vim.api.nvim_get_current_buf()
    local opts = { noremap = true, silent = true, buffer = bufnr }

    vim.keymap.set("n", "<Space>cl", "vim.lsp.codelens.run", opts)

    vim.keymap.set("n", "<Space>hs", ht.hoogle.hoogle_signature)

    vim.keymap.set("n", "<Space>ea", ht.lsp.buf_eval_all, opts)

    vim.keymap.set("n", "<leader>rr", ht.repl.toggle, opts)

    local function _12_()
        return ht.repl.toggle(vim.api.nvim_buf_get_name(0))
    end
    vim.keymap.set("n", "<leader>rf", _12_, opts)
    return vim.keymap.set("n", "<leader>rq", ht.repl.quit, opts)
end

vim.api.nvim_create_augroup("HaskellTools", { clear = true })
do
    local _ = {
        vim.api.nvim_create_autocmd(
            "FileType",
            { callback = HaskellToolsFn, group = "HaskellTools", pattern = "haskell" }
        ),
        vim.api.nvim_create_autocmd(
            "FileType",
            { callback = HaskellToolsFn, group = "HaskellTools", pattern = "cabal" }
        ),
    }
end

vim.api.nvim_set_keymap("c", "<C-a>", "<Home>", { nowait = true })
vim.api.nvim_set_keymap("c", "<C-e>", "<End>", { nowait = true })
vim.api.nvim_set_keymap("c", "<C-f>", "<Right>", { nowait = true })
vim.api.nvim_set_keymap("c", "<C-b>", "<Left>", { nowait = true })
vim.api.nvim_set_keymap("c", "<ESC>b", "<Home>", { nowait = true })
vim.api.nvim_set_keymap("c", "<ESC>f", "<End>", { nowait = true })
vim.api.nvim_set_keymap("c", "w;", "w<CR>", { nowait = true })

vim.keymap.del("n", "<C-w><C-d>")
if pcall(require, "which-key") then
    local wk = package.loaded["which-key"]
    local t
    local function _13_(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end
    t = _13_

    wk.add({
        { "s",   group = "Sayonara", silent = false },
        { "s;",  "Sayonara!<CR>",    desc = "Forget File Buffer",            silent = false },
        { "sa;", "Sayonara<CR>",     desc = "Forget File Buffer And Layout", silent = false },
        mode = { "c" },
    })

    wk.add({
        { "J", ":m '>+1<CR>gv=gv", desc = "Move line up" },
        { "K", ":m '<-2<CR>gv=gv", desc = "Move line down" },
        mode = { "v" },
    })

    vim.g.kitty_navigator_no_mappings = true
    local function tmux_or_kitty(dir)
        if vim.fn.exists('$TMUX') == 1 then
            return ':TmuxNavigate' .. dir .. '<CR>'
        else
            return ':KittyNavigate' .. dir .. '<CR>'
        end
    end

    wk.add({
        { "gk",    "k",                                   desc = "Move up one actual line" },
        { "gj",    "j",                                   desc = "Move down one actual line" },
        { "g0",    "0",                                   desc = "Move to the beginning of the current (actual) line" },
        { "g$",    "$",                                   desc = "Move to the end of the current (actual) line" },
        { "k",     "gk",                                  desc = "Move up one visual line" },
        { "j",     "gj",                                  desc = "Move down one visual line" },
        { "0",     "g0",                                  desc = "Move to the beginning of the current (visual) line" },
        { "$",     "g$",                                  desc = "Move to the end of the current (visual) line" },
        { "<C-f>", ":TSHighlightCapturesUnderCursor<CR>", desc = "Show highlight group" },
        { "<F10>", ":TSHighlightCapturesUnderCursor<CR>", desc = "Show highlight group" },
        { "<C-n>", ":bnext<CR>",                          desc = "Next buffer" },
        { "<C-b>", ":bprev<CR>",                          desc = "Prev Buffer" },
        { "'",     "`",                                   desc = "Jump to line of mark" },
        { "`",     "'",                                   desc = "Jump to mark^" },
        mode = { "n", "v" },
        { "z",     group = "Folds",              silent = false },
        { "z[",    require("ufo").openAllFolds,  desc = "Open all folds" },
        { "z]",    require("ufo").closeAllFolds, desc = "Close all folds" },
        { "<C-s>", ":Scratch<CR>",               desc = "Scratch Buffer" },
        { "<C-h>", tmux_or_kitty('Left'),        desc = "Select Window/Pane Left" },
        { "<C-l>", tmux_or_kitty('Right'),       desc = "Select Window/Pane Right" },
        { "<C-k>", tmux_or_kitty('Up'),          desc = "Select Window/Pane Up" },
        { "<C-j>", tmux_or_kitty('Down'),        desc = "Select Window/Pane Down" },
        { "n",     "n:lua HlNext(0.4)<CR>",      desc = "Glow Next" },
        { "N",     "N:lua HlNext(0.4)<CR>",      desc = "Glow Prev" },
        { ";",     ":",                          desc = "Quick Command" },
    })

    local function _14_()
        return vim.diagnostic.open_float()
    end

    local function _15_()
        return vim.diagnostic.goto_next()
    end

    local function _16_()
        return vim.diagnostic.goto_prev()
    end

    local function _17_()
        return vim.diagnostic.hide()
    end
    local function _18_()
        return vim.diagnostic.show()
    end

    local function _19_()
        return vim.lsp.buf.code_action()
    end
    local function _20_()
        return vim.lsp.buf.definition()
    end
    local function _21_()
        return vim.lsp.buf.declaration()
    end

    local function _22_()
        return vim.diagnostic.open_float()
    end

    local function _23_()
        return vim.diagnostic.open_float()
    end

    local function _24_()
        if pcall(require, "lspsaga.hover") then
            return require("lspsaga.hover"):render_hover_doc()
        else
            return vim.lsp.buf.hover()
        end
    end

    local function _25_()
        return vim.lsp.buf.implementation()
    end

    local function _26_()
        return vim.lsp.util.show_line_diagnostics()
    end

    local function _27_()
        return vim.diagnostic.goto_next()
    end

    local function _28_()
        return vim.diagnostic.goto_prev()
    end

    local function _29_()
        return vim.diagnostic.signature_help()
    end

    local function _30_()
        return vim.lsp.buf.type_definition()
    end

    local function _31_()
        if pcall(require, "lspsaga.hover") then
            return require("lspsaga.hover"):render_hover_doc()
        else
            return vim.lsp.buf.hover()
        end
    end

    local function _32_()
        return package.loaded.gitsigns.next_hunk()
    end

    local function _33_()
        return package.loaded.gitsigns.prev_hunk()
    end

    local function _34_()
        return package.loaded.gitsigns.preview_hunk()
    end

    local function _35_()
        return package.loaded.gitsigns.blame_line({ full = true })
    end

    local function _36_()
        return package.loaded.gitsigns.toggle_current_line_blame()
    end

    local function _37_()
        return package.loaded.gitsigns.diffthis()
    end

    local function _38_()
        return package.loaded.gitsigns.toggle_deleted()
    end
    wk.add({
        { "gf",         ":e <cfile><CR>",         desc = "Open file (always)" },
        { "gd",         group = "Vim Diagnostic", silent = false },
        { "gdf",        _14_,                     desc = "Open diagnostic options" },
        { "gdn",        _15_,                     desc = "Goto next error/warning" },
        { "gdp",        _16_,                     desc = "Goto prev error/warning" },
        { "gdh",        _17_,                     desc = "Hide diagnostics" },
        { "gds",        _18_,                     desc = "Show diagnostics" },
        { "gl",         group = "Vim LSP",        silent = false },
        { "gla",        _19_,                     desc = "Code actions" },
        { "gld",        _20_,                     desc = "Show definition" },
        { "glD",        _21_,                     desc = "Show declaration" },
        { "gle",        _22_,                     desc = "Show error messages" },
        { "glf",        _23_,                     desc = "Open diagnostic options" },
        { "glh",        _24_,                     desc = "LSP Hover" },
        { "gli",        _25_,                     desc = "Show implementation" },
        { "gll",        _26_,                     desc = "Show line diagnostics" },
        { "gln",        _27_,                     desc = "Goto next error/warning" },
        { "glp",        _28_,                     desc = "Goto prev error/warning" },
        { "glr",        ":IncRename ",            desc = "Rename identifier" },
        { "gls",        _29_,                     desc = "Show signature" },
        { "glt",        _30_,                     desc = "Show type definition" },
        { "gK",         _31_,                     desc = "LSP Hover" },
        { "go",         group = "Git Signs",      silent = false },
        { "gon",        _32_,                     desc = "Next hunk" },
        { "gop",        _33_,                     desc = "Prev hunk" },
        { "goP",        _34_,                     desc = "Preview hunk" },
        { "gol",        _35_,                     desc = "Full blame" },
        { "got",        _36_,                     desc = "Toggle line blame" },
        { "god",        _37_,                     desc = "Split diff" },
        { "goD",        _38_,                     desc = "Show deleted lines" },
        { "g<leader>c", ":set spell!<CR>",        desc = "Spell checker" },
        { "g<leader>n", ":tabnext<CR>",           desc = "Next tab" },
        { "g<leader>b", ":tabprev<CR>",           desc = "Prev tab" },
        { "g<leader>G", ":Goyo<CR>",              desc = "Focused Editing" },
        { "g<leader>l", group = "Lusty Juggler",  silent = false },
        mode = { "n" },
        { "g<leader>s",  ":split<CR>",                 desc = "Split window (H)" },
        { "g<leader>v",  ":vertical split<CR>",        desc = "Split window (V)" },
        { "g<leader>=",  "<C-w>=",                     desc = "Equally high and wide" },
        { "g<leader>+",  ":resize +10<CR>",            desc = "Increase height" },
        { "g<leader>-",  ":resize -10<CR>",            desc = "Decrease height" },
        { "<C-w>",       group = "Window",             silent = false },
        { "<C-w>J",      ":resize -10<CR>",            desc = "Decrease height" },
        { "<C-w>K",      ":resize +10<CR>",            desc = "Increase height" },
        { "<C-w>L",      ":vertical resize +10<CR>",   desc = "Increase width" },
        { "<C-w>H",      ":vertical resize -10<CR>",   desc = "Decrease width" },
        { "<C-w>j",      "<C-w>j",                     desc = "Move down" },
        { "<C-w>k",      "<C-w>k",                     desc = "Move up" },
        { "<C-w>l",      "<C-w>L",                     desc = "Move right" },
        { "<C-w>h",      "<c-w>H",                     desc = "Move left" },
        { "g<leader>dt", ":SSave! default | qall<CR>", desc = "Save default session and quit" },
        { "g<leader>Dt", ":SLoad default<CR>",         desc = "Load default session" },
    })

    local function pumvisible()
        return tonumber(vim.fn.pumvisible()) ~= 0
    end

    local function feedkeys(keys)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
    end

    local function _41_(...)
        return {
            { "jk", "<Esc>", desc = "Quick escape" },
            {
                "<C-n>",
                function()
                    if pumvisible() then
                        feedkeys '<C-n>'
                    else
                        feedkeys '<C-x><C-o>'
                    end
                end,
                --pumvisible() ? '<C-n>' : '<C—x><C-o>',
                { noremap = true, expr = true },
                desc = "Autocomplete",
            },
            mode = { "i" },
        }
    end
    wk.add(_41_(...))

    wk.add({
        {
            "<C-Space>",
            group = "Tmux prefix-alike",
            silent = false,
        },
        { "<C-Space>vt", "<C-\\><C-n><C-w>v",                    desc = "Split vertically" },
        { "<C-Space>ht", "<C-\\><C-n><C-w>s",                    desc = "Split horizontally" },
        { "<C-Space>dt", "<C-\\><C-n>SSave! default | qall<CR>", desc = "Save default session and quit" },
        { "<C-Space>Dt", "<C-\\><C-n>:SLoad default<CR>",        desc = "Load default session" },
        { "<C-v>t",      "<C-\\><C-n><C-w>v",                    desc = "Split vertically" },
        { "<C-s>t",      "<C-\\><C-n><C-w>v",                    desc = "Split vertically" },
        mode = "t",
        { "<C-w>",      name = "+window" },
        { "<C-w>w",     "<C-\\><C-n>",                desc = "Escape terminal" },
        { "<C-w>c",     ":tabnew<CR>",                desc = "Create new tab" },
        { "<C-w>n",     ":tabnext<CR>",               desc = "Next Tab" },
        { "<C-w>b",     ":tabprev<CR>",               desc = "Prev Tab" },
        { "<C-w>+",     ":vertical resize +10<CR>",   desc = "Increase height" },
        { "<C-w>-",     ":vertical resize -10<CR>",   desc = "Decrease height" },
        { "<C-w>J",     ":resize -10<CR>",            desc = "Decrease height" },
        { "<C-w>K",     ":resize +10<CR>",            desc = "Increase height" },
        { "<C-w>L",     ":vertical resize +10",       desc = "Increase width" },
        { "<C-w>H",     ":vertical resize -10",       desc = "Decrease width" },
        { "<C-w>j",     "<C-w>j",                     desc = "Move down" },
        { "<C-w>k",     "<C-w>k",                     desc = "Move up" },
        { "<C-w>l",     "<C-w>L",                     desc = "Move right" },
        { "<C-w>h",     "<c-w>H",                     desc = "Move left" },
        { "<C-w>D",     ":SLoad default<CR>",         desc = "Load default session" },
        { "<C-Space>",  name = "+window" },
        { "<C-Space>c", ":tabnew<CR>",                desc = "Create new tab" },
        { "<C-Space>n", ":tabnext<CR>",               desc = "Next Tab" },
        { "<C-Space>b", ":tabprev<CR>",               desc = "Prev Tab" },
        { "<C-Space>s", ":split<CR>",                 desc = "Split Window (H)" },
        { "<C-Space>v", ":resize -10<CR>",            desc = "Decrease width" },
        { "<C-Space>=", "<C-w>=",                     desc = "Equally high and wide" },
        { "<C-Space>+", ":resize -10<CR>",            desc = "Decrease width" },
        { "<C-Space>-", ":resize -10<CR>",            desc = "Decrease width" },
        { "<C-Space>>", ":resize -10<CR>",            desc = "Decrease width" },
        { "<C-Space><", ":resize -10<CR>",            desc = "Decrease width" },
        { "<C-Space>l", [5] = ":resize +10<CR>",      desc = "Increase width" },
        { "<C-Space>d", ":SSave! default | qall<CR>", desc = "Save default session and quit" },
        { "<C-Space>D", ":SLoad default<CR>",         desc = "Load default session" },
    })
else
end

vim.api.nvim_create_augroup("Utilities", { clear = true })
do
    local open_at_last_position
    local function _47_()
        local and_48_ = (vim.fn.line("'\"") > 1)
        if and_48_ then
            and_48_ = (vim.fn.line("'\"") <= vim.fn.line("$"))
        end
        if and_48_ then
            return vim.cmd('exe "normal! g`\\""')
        else
            return nil
        end
    end
    open_at_last_position = _47_
    do
        local _ = {
            vim.api.nvim_create_autocmd(
                "BufRead",
                { callback = open_at_last_position, group = "Utilities", pattern = "*" }
            ),
        }
    end
end

vim.api.nvim_create_augroup("LatexHelp", { clear = true })
local function _50_()
    vim.opt["fileencoding"] = "ascii"
    return nil
end
do
    local _ = { vim.api.nvim_create_autocmd("FileType", { callback = _50_, group = "LatexHelp", pattern = "tex" }) }
end

vim.api.nvim_create_augroup("HelpFiles", { clear = true })

local function _51_()
    return vim.cmd(("source " .. vim.fn.stdpath("config") .. "/ftplugin/help.vim"))
end
do
    local _ = { vim.api.nvim_create_autocmd("FileType", { callback = _51_, group = "HelpFiles", pattern = "*" }) }
end

vim.api.nvim_create_augroup("Scala", { clear = true })
local function _52_()
    vim.opt["filetype"] = "scala"
    return nil
end
local function _53_()
    vim.opt["filetype"] = "scala"
    return nil
end
do
    local _ = {
        vim.api.nvim_create_autocmd("BufNewFile", { callback = _52_, group = "Scala", pattern = "*.sc" }),
        vim.api.nvim_create_autocmd("BufRead", { callback = _53_, group = "Scala", pattern = "*.sc" }),
    }
end

vim.g["netrw_browse_split"] = 4
vim.g["netrw_altv"] = 1
vim.g["netrw_list_hide"] = "^\\."
vim.g["netrw_hide"] = 1

vim.cmd("colorscheme silverscreen")
