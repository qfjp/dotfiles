require("bootstrap")
local packer_path = vim.fn.stdpath('data') .. '/site/pack/packer/start'
Bootstrap(packer_path, "wbthomason", "packer.nvim", {})
vim.opt.rtp:prepend(string.format('%s/%s', BOOTSTRAP_PATH, "lazy.nvim"))
vim.opt.rtp:prepend(packer_path)
vim.opt.rtp:prepend(string.format('%s/%s', packer_path, "packer.nvim"))
