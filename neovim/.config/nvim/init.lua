vim.opt.termguicolors = true
require("bootstrap")
Bootstrap(BOOTSTRAP_PATH, 'lewis6991', 'impatient.nvim', { { "enable_profile" } })
vim.opt.rtp:prepend(string.format('%s/%s', BOOTSTRAP_PATH, "impatient.nvim"))
require("bootstrap.lazy")
require('startup')
