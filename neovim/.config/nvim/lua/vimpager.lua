vim.g.no_man_maps=1
vim.g.easycomplete_lsp_checking=0
vim.g.easycomplete_diagnostics_enable=0

vim.opt.laststatus=0
vim.opt.scrolloff=999
vim.opt.list = false
vim.opt.cursorline = false
vim.opt.expandtab = false
vim.opt.smarttab = false
vim.opt.tabstop=4
vim.opt.shiftwidth=4
vim.opt.wrapscan = false
vim.opt.smartcase = true
if vim.fn.exists('+colorcolumn') then
  vim.opt.cc="0"
end

vim.opt.foldcolumn="0"

--vim.opt.wrap = false
vim.opt.linebreak = true

vim.opt.number = false
vim.opt.relativenumber = false

vim.cmd([[noh]]) -- Start without highlights

vim.g.mapleader="<c-a>"
vim.g.maplocalleader="<c-a>"
vim.api.nvim_set_keymap("n", "q", ":q!<CR>", {nowait=true})
vim.api.nvim_set_keymap("n", "<Space>", "<C-d>", {nowait=true})
vim.api.nvim_set_keymap("n", "b", "<C-u>", {nowait=true})
vim.api.nvim_set_keymap("n", "j", "<C-e>", {nowait=true})
vim.api.nvim_set_keymap("n", "k", "<C-y>", {nowait=true})

if vim.fn.exists(":QuickScopeToggle") then
    vim.b.qs_local_disable = 1
end
vim.cmd([[colorscheme silverscreen]])
vim.cmd([[Man!]])
