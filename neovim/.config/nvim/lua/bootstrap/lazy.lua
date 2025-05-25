require("bootstrap")
--local lazy_path = vim.fn.stdpath("data") .. "/lazy"
Bootstrap(BOOTSTRAP_PATH, "folke", "lazy.nvim", {{'--filter=blob:none', '--branch=stable'}})
vim.opt.rtp:prepend(string.format('%s/%s', BOOTSTRAP_PATH, "lazy.nvim"))

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  --install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
