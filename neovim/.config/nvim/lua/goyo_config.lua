vim.g["limelight_priority"] = -1

vim.g["limelight_conceal_ctermfg"] = 240
vim.g["limelight_conceal_guifg"] = 240
vim.g["limelight_paragraph_span"] = 0

local function GoyoEnterFn()
    vim.b["sign_status"] = vim.opt.signcolumn._value
    vim.b["cursor_line"] = vim.opt.cursorline._value
    vim.b["show_cmd"] = vim.opt.showcmd._value
    return vim.cmd("silent !tmux set status off", nil)
end

local function GoyoLeaveFn()
    vim.cmd("silent !tmux set status on")
    vim.opt["signcolumn"] = vim.b.sign_status
    vim.opt["cursorline"] = vim.b.cursor_line
    vim.opt["showcmd"] = vim.b.show_cmd
    vim.cmd("unlet b:sign_status")
    vim.cmd("unlet b:cursor_line")
    vim.cmd("unlet b:show_cmd")
    return vim.cmd("TwilightDisable")
end

local goyo_group = vim.api.nvim_create_augroup("Goyo", {clear = true})
vim.api.nvim_create_autocmd("User", {
    pattern = "GoyoEnter",
    group = goyo_group,
    callback = GoyoEnterFn
})
vim.api.nvim_create_autocmd("User", {
    pattern = "GoyoLeave",
    group = goyo_group,
    callback = GoyoLeaveFn
})
