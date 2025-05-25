require("bootstrap")
--Bootstrap(BOOTSTRAP_PATH, "Olical", "nfnl", {})
Bootstrap(BOOTSTRAP_PATH, "rktjmp", "hotpot.nvim", {})
Bootstrap(BOOTSTRAP_PATH, "katawful", "katcros-fnl", {})
vim.opt.rtp:prepend(string.format('%s/%s', BOOTSTRAP_PATH, "hotpot.nvim"))
--vim.opt.rtp:prepend(string.format('%s/%s', BOOTSTRAP_PATH, "nfnl"))
vim.opt.rtp:prepend(string.format('%s/%s', BOOTSTRAP_PATH, "katcros-fnl"))
if pcall(require, "hotpot") then
    require('hotpot').setup({
        provide_require_fennel = true,
        enable_hotpot_diagnostics = true,
        compiler = {
            modules = {
                correlate = true
            },
        },
        macros = {
            env = "_COMPILER"
        }
    })
    pcall(require, "startup")
end
