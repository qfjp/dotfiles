



 vim.g["limelight_priority"] = -1

 vim.g["limelight_conceal_ctermfg"] = 240
 vim.g["limelight_conceal_guifg"] = 240
 vim.g["limelight_paragraph_span"] = 0


 local function _1_()

 vim.b["sign_status"] = vim.opt.signcolumn._value return vim.cmd("silent !tmux set status off", nil) end GoyoEnterFn = _1_




 local function _2_()
 vim.cmd("silent !tmux set status on")
 vim.opt["signcolumn"] = vim.b.sign_status
 vim.opt["cursorline"] = vim.b.cursor_line
 vim.opt["showcmd"] = vim.b.show_cmd
 vim.cmd("unlet b:sign_status")
 vim.cmd("unlet b:cursor_line")
 vim.cmd("unlet b:show_cmd")
 return vim.cmd("TwilightDisable") end GoyoLeaveFn = _2_

 vim.cmd(("augroup " .. "Goyo")) vim.cmd("autocmd!") do
 do local _ = {vim.cmd("autocmd User GoyoEnter call v:lua.GoyoEnterFn()"), vim.cmd("autocmd User GoyoLeave call v:lua.GoyoLeaveFn()")} end end return vim.cmd("augroup END")