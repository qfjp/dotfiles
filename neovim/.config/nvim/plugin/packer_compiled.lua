-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = true
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/dan/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/dan/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/dan/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/dan/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/dan/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  AnsiEsc = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/AnsiEsc",
    url = "/home/dan/.config/nvim/bundle/AnsiEsc"
  },
  Lusty = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/Lusty",
    url = "https://github.com/sjbach/Lusty"
  },
  SyntaxAttr = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/SyntaxAttr",
    url = "/home/dan/.config/nvim/bundle/SyntaxAttr"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-dictionary"] = {
    after_files = { "/home/dan/.local/share/nvim/site/pack/packer/opt/cmp-dictionary/after/plugin/cmp_dictionary.vim" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/dan/.local/share/nvim/site/pack/packer/opt/cmp-dictionary",
    url = "https://github.com/uga-rosa/cmp-dictionary"
  },
  ["cmp-greek"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/cmp-greek",
    url = "https://github.com/max397574/cmp-greek"
  },
  ["cmp-latex-symbols"] = {
    after_files = { "/home/dan/.local/share/nvim/site/pack/packer/opt/cmp-latex-symbols/after/plugin/cmp_latex.lua" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/dan/.local/share/nvim/site/pack/packer/opt/cmp-latex-symbols",
    url = "https://github.com/kdheepak/cmp-latex-symbols"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lsp-signature-help"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp-signature-help",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help"
  },
  ["cmp-nvim-lua"] = {
    after_files = { "/home/dan/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lua/after/plugin/cmp_nvim_lua.lua" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/dan/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["cmp-spell"] = {
    after_files = { "/home/dan/.local/share/nvim/site/pack/packer/opt/cmp-spell/after/plugin/cmp-spell.lua" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/dan/.local/share/nvim/site/pack/packer/opt/cmp-spell",
    url = "https://github.com/f3fora/cmp-spell"
  },
  ["cmp-vsnip"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/cmp-vsnip",
    url = "https://github.com/hrsh7th/cmp-vsnip"
  },
  conjure = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/conjure",
    url = "https://github.com/Olical/conjure"
  },
  ["elm-vim"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/dan/.local/share/nvim/site/pack/packer/opt/elm-vim",
    url = "https://github.com/ElmCast/elm-vim"
  },
  ["emmet-vim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/dan/.local/share/nvim/site/pack/packer/opt/emmet-vim",
    url = "https://github.com/mattn/emmet-vim"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  ["gitsigns.nvim"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["goyo.vim"] = {
    commands = { "Goyo", "GoyoEnter", "GoyoLeave" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/dan/.local/share/nvim/site/pack/packer/opt/goyo.vim",
    url = "https://github.com/junegunn/goyo.vim"
  },
  ["haskell-vim"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/dan/.local/share/nvim/site/pack/packer/opt/haskell-vim",
    url = "https://github.com/neovimhaskell/haskell-vim"
  },
  ["hotpot.nvim"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/hotpot.nvim",
    url = "https://github.com/rktjmp/hotpot.nvim"
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/impatient.nvim",
    url = "https://github.com/lewis6991/impatient.nvim"
  },
  ["lightline-bufferline"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/lightline-bufferline",
    url = "https://github.com/mengelbrecht/lightline-bufferline"
  },
  ["lightline.vim"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/lightline.vim",
    url = "https://github.com/itchyny/lightline.vim"
  },
  ["lightspeed.nvim"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/lightspeed.nvim",
    url = "https://github.com/ggandor/lightspeed.nvim"
  },
  ["lspkind.nvim"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/lspkind.nvim",
    url = "https://github.com/onsails/lspkind.nvim"
  },
  neoformat = {
    commands = { "Neoformat" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/dan/.local/share/nvim/site/pack/packer/opt/neoformat",
    url = "https://github.com/sbdchd/neoformat"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\n@\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\19nvim-autopairs\frequire\0" },
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-jdtls"] = {
    config = { "\27LJ\2\n*\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\15java_jdtls\frequireÛ\1\1\0\6\0\v\0\0166\0\0\0009\0\1\0009\0\2\0'\2\3\0005\3\4\0B\0\3\0026\1\0\0009\1\1\0019\1\5\1'\3\6\0005\4\a\0=\0\b\0043\5\t\0=\5\n\4B\1\3\1K\0\1\0\rcallback\0\ngroup\1\0\2\fpattern\tjava\tdesc&Attach an instance of jdtls (lsp)\rFileType\24nvim_create_autocmd\1\0\1\nclear\2\14JavaGroup\24nvim_create_augroup\bapi\bvim\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/dan/.local/share/nvim/site/pack/packer/opt/nvim-jdtls",
    url = "https://github.com/mfussenegger/nvim-jdtls"
  },
  ["nvim-lsp-installer"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-metals"] = {
    config = { "\27LJ\2\nG\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\25initialize_or_attach\vmetals\frequireî\1\1\0\6\0\r\0\0186\0\0\0009\0\1\0009\0\2\0'\2\3\0005\3\4\0B\0\3\0026\1\0\0009\1\1\0019\1\5\1'\3\6\0005\4\b\0005\5\a\0=\5\t\4=\0\n\0043\5\v\0=\5\f\4B\1\3\1K\0\1\0\rcallback\0\ngroup\fpattern\1\0\1\tdesc'Attach an instance of metals (lsp)\1\3\0\0\nscala\bsbt\rFileType\24nvim_create_autocmd\1\0\1\nclear\2\15ScalaGroup\24nvim_create_augroup\bapi\bvim\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/dan/.local/share/nvim/site/pack/packer/opt/nvim-metals",
    url = "https://github.com/scalameta/nvim-metals"
  },
  ["nvim-minimap"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/nvim-minimap",
    url = "https://github.com/rinx/nvim-minimap"
  },
  ["nvim-reload"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/nvim-reload",
    url = "https://github.com/famiu/nvim-reload"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["parinfer-rust"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/dan/.local/share/nvim/site/pack/packer/opt/parinfer-rust",
    url = "https://github.com/eraserhd/parinfer-rust"
  },
  playground = {
    commands = { "TSHighlightCapturesUnderCursor", "TSPlaygroundToggle" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/dan/.local/share/nvim/site/pack/packer/opt/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["targets.vim"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/targets.vim",
    url = "https://github.com/wellle/targets.vim"
  },
  ["twilight.nvim"] = {
    commands = { "Twilight", "TwilightEnable", "TwilightDisable" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/dan/.local/share/nvim/site/pack/packer/opt/twilight.nvim",
    url = "https://github.com/folke/twilight.nvim"
  },
  undotree = {
    commands = { "UndotreeToggle" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/dan/.local/share/nvim/site/pack/packer/opt/undotree",
    url = "https://github.com/mbbill/undotree"
  },
  ["vim-autoresize"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/vim-autoresize",
    url = "https://github.com/kovetskiy/vim-autoresize"
  },
  ["vim-devicons"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/vim-devicons",
    url = "https://github.com/ryanoasis/vim-devicons"
  },
  ["vim-easy-align"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/vim-easy-align",
    url = "https://github.com/junegunn/vim-easy-align"
  },
  ["vim-fennel-syntax"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/dan/.local/share/nvim/site/pack/packer/opt/vim-fennel-syntax",
    url = "https://github.com/mnacamura/vim-fennel-syntax"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-haskellConcealPlus"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/vim-haskellConcealPlus",
    url = "/home/dan/.config/nvim/bundle/vim-haskellConcealPlus"
  },
  ["vim-janah"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/vim-janah",
    url = "https://github.com/mhinz/vim-janah"
  },
  ["vim-markdown-enhancements"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/dan/.local/share/nvim/site/pack/packer/opt/vim-markdown-enhancements",
    url = "https://github.com/mattly/vim-markdown-enhancements"
  },
  ["vim-obsession"] = {
    commands = { "Obsess", "SSave", "SLoad", "SClose", "SDelete", "mksession" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/dan/.local/share/nvim/site/pack/packer/opt/vim-obsession",
    url = "https://github.com/tpope/vim-obsession"
  },
  ["vim-remembrall"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/vim-remembrall",
    url = "https://github.com/urbainvaes/vim-remembrall"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-sayonara"] = {
    commands = { "Sayonara", "Sayonara!", "S", "Sa" },
    config = { "\27LJ\2\n¤\1\0\0\5\0\t\0\0196\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0004\4\0\0B\0\4\0016\0\0\0009\0\1\0009\0\2\0'\2\5\0'\3\6\0004\4\0\0B\0\4\0016\0\0\0009\0\a\0+\1\2\0=\1\b\0K\0\1\0\26sayonara_confirm_quit\6g\rSayonara\aSa\14Sayonara!\6S\29nvim_create_user_command\bapi\bvim\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/dan/.local/share/nvim/site/pack/packer/opt/vim-sayonara",
    url = "https://github.com/mhinz/vim-sayonara"
  },
  ["vim-speeddating"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/vim-speeddating",
    url = "https://github.com/tpope/vim-speeddating"
  },
  ["vim-startify"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/vim-startify",
    url = "https://github.com/mhinz/vim-startify"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vim-textobj-latex"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/dan/.local/share/nvim/site/pack/packer/opt/vim-textobj-latex",
    url = "https://github.com/rbonvall/vim-textobj-latex"
  },
  ["vim-textobj-user"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/vim-textobj-user",
    url = "https://github.com/kana/vim-textobj-user"
  },
  ["vim-tmux-navigator"] = {
    config = { "\27LJ\2\n¶\2\0\0\6\0\16\0!6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\a\0'\4\b\0005\5\t\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\n\0'\4\v\0005\5\f\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\r\0'\4\14\0005\5\15\0B\0\5\1K\0\1\0\1\0\1\vsilent\2\26:TmuxNavigateDown<CR>\n<C-j>\1\0\1\vsilent\2\24:TmuxNavigateUp<CR>\n<C-k>\1\0\1\vsilent\2\27:TmuxNavigateRight<CR>\n<C-l>\1\0\1\vsilent\2\26:TmuxNavigateLeft<CR>\n<C-h>\5\bset\vkeymap\bvim\0" },
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/vim-tmux-navigator",
    url = "https://github.com/christoomey/vim-tmux-navigator"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/vim-vsnip",
    url = "https://github.com/hrsh7th/vim-vsnip"
  },
  vimtex = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/dan/.local/share/nvim/site/pack/packer/opt/vimtex",
    url = "https://github.com/lervag/vimtex"
  },
  vimwiki = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/dan/.local/share/nvim/site/pack/packer/opt/vimwiki",
    url = "https://github.com/vimwiki/vimwiki"
  },
  ["zest.nvim"] = {
    config = { "\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\tzest\frequire\0" },
    loaded = true,
    path = "/home/dan/.local/share/nvim/site/pack/packer/start/zest.nvim",
    url = "https://github.com/tsbohc/zest.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: nvim-autopairs
time([[Config for nvim-autopairs]], true)
try_loadstring("\27LJ\2\n@\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\19nvim-autopairs\frequire\0", "config", "nvim-autopairs")
time([[Config for nvim-autopairs]], false)
-- Config for: vim-tmux-navigator
time([[Config for vim-tmux-navigator]], true)
try_loadstring("\27LJ\2\n¶\2\0\0\6\0\16\0!6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\a\0'\4\b\0005\5\t\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\n\0'\4\v\0005\5\f\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\r\0'\4\14\0005\5\15\0B\0\5\1K\0\1\0\1\0\1\vsilent\2\26:TmuxNavigateDown<CR>\n<C-j>\1\0\1\vsilent\2\24:TmuxNavigateUp<CR>\n<C-k>\1\0\1\vsilent\2\27:TmuxNavigateRight<CR>\n<C-l>\1\0\1\vsilent\2\26:TmuxNavigateLeft<CR>\n<C-h>\5\bset\vkeymap\bvim\0", "config", "vim-tmux-navigator")
time([[Config for vim-tmux-navigator]], false)
-- Config for: zest.nvim
time([[Config for zest.nvim]], true)
try_loadstring("\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\tzest\frequire\0", "config", "zest.nvim")
time([[Config for zest.nvim]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file S lua require("packer.load")({'vim-sayonara'}, { cmd = "S", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[au CmdUndefined Sayonara! ++once lua require"packer.load"({'vim-sayonara'}, {}, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Sa lua require("packer.load")({'vim-sayonara'}, { cmd = "Sa", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Sayonara lua require("packer.load")({'vim-sayonara'}, { cmd = "Sayonara", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Obsess lua require("packer.load")({'vim-obsession'}, { cmd = "Obsess", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file SSave lua require("packer.load")({'vim-obsession'}, { cmd = "SSave", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file SLoad lua require("packer.load")({'vim-obsession'}, { cmd = "SLoad", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file SClose lua require("packer.load")({'vim-obsession'}, { cmd = "SClose", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file SDelete lua require("packer.load")({'vim-obsession'}, { cmd = "SDelete", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file mksession lua require("packer.load")({'vim-obsession'}, { cmd = "mksession", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Twilight lua require("packer.load")({'twilight.nvim'}, { cmd = "Twilight", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TwilightEnable lua require("packer.load")({'twilight.nvim'}, { cmd = "TwilightEnable", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TwilightDisable lua require("packer.load")({'twilight.nvim'}, { cmd = "TwilightDisable", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Goyo lua require("packer.load")({'goyo.vim'}, { cmd = "Goyo", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file GoyoEnter lua require("packer.load")({'goyo.vim'}, { cmd = "GoyoEnter", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file GoyoLeave lua require("packer.load")({'goyo.vim'}, { cmd = "GoyoLeave", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file UndotreeToggle lua require("packer.load")({'undotree'}, { cmd = "UndotreeToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TSHighlightCapturesUnderCursor lua require("packer.load")({'playground'}, { cmd = "TSHighlightCapturesUnderCursor", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TSPlaygroundToggle lua require("packer.load")({'playground'}, { cmd = "TSPlaygroundToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Neoformat lua require("packer.load")({'neoformat'}, { cmd = "Neoformat", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType xml ++once lua require("packer.load")({'emmet-vim', 'elm-vim'}, { ft = "xml" }, _G.packer_plugins)]]
vim.cmd [[au FileType fennel ++once lua require("packer.load")({'vim-fennel-syntax', 'parinfer-rust'}, { ft = "fennel" }, _G.packer_plugins)]]
vim.cmd [[au FileType scheme ++once lua require("packer.load")({'parinfer-rust'}, { ft = "scheme" }, _G.packer_plugins)]]
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'vim-markdown-enhancements'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType sbt ++once lua require("packer.load")({'nvim-metals'}, { ft = "sbt" }, _G.packer_plugins)]]
vim.cmd [[au FileType scala ++once lua require("packer.load")({'nvim-metals'}, { ft = "scala" }, _G.packer_plugins)]]
vim.cmd [[au FileType vimwiki ++once lua require("packer.load")({'vimwiki'}, { ft = "vimwiki" }, _G.packer_plugins)]]
vim.cmd [[au FileType java ++once lua require("packer.load")({'nvim-jdtls'}, { ft = "java" }, _G.packer_plugins)]]
vim.cmd [[au FileType tex ++once lua require("packer.load")({'cmp-latex-symbols', 'cmp-spell', 'cmp-dictionary', 'vimtex', 'vim-textobj-latex'}, { ft = "tex" }, _G.packer_plugins)]]
vim.cmd [[au FileType lua ++once lua require("packer.load")({'cmp-nvim-lua'}, { ft = "lua" }, _G.packer_plugins)]]
vim.cmd [[au FileType vim ++once lua require("packer.load")({'cmp-nvim-lua'}, { ft = "vim" }, _G.packer_plugins)]]
vim.cmd [[au FileType clojure ++once lua require("packer.load")({'parinfer-rust'}, { ft = "clojure" }, _G.packer_plugins)]]
vim.cmd [[au FileType haskell ++once lua require("packer.load")({'haskell-vim'}, { ft = "haskell" }, _G.packer_plugins)]]
vim.cmd [[au FileType lisp ++once lua require("packer.load")({'parinfer-rust'}, { ft = "lisp" }, _G.packer_plugins)]]
vim.cmd [[au FileType html ++once lua require("packer.load")({'emmet-vim', 'elm-vim'}, { ft = "html" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au BufWritePre * ++once lua require("packer.load")({'neoformat'}, { event = "BufWritePre *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /home/dan/.local/share/nvim/site/pack/packer/opt/haskell-vim/ftdetect/haskell.vim]], true)
vim.cmd [[source /home/dan/.local/share/nvim/site/pack/packer/opt/haskell-vim/ftdetect/haskell.vim]]
time([[Sourcing ftdetect script at: /home/dan/.local/share/nvim/site/pack/packer/opt/haskell-vim/ftdetect/haskell.vim]], false)
time([[Sourcing ftdetect script at: /home/dan/.local/share/nvim/site/pack/packer/opt/vim-fennel-syntax/ftdetect/fennel.vim]], true)
vim.cmd [[source /home/dan/.local/share/nvim/site/pack/packer/opt/vim-fennel-syntax/ftdetect/fennel.vim]]
time([[Sourcing ftdetect script at: /home/dan/.local/share/nvim/site/pack/packer/opt/vim-fennel-syntax/ftdetect/fennel.vim]], false)
time([[Sourcing ftdetect script at: /home/dan/.local/share/nvim/site/pack/packer/opt/elm-vim/ftdetect/elm.vim]], true)
vim.cmd [[source /home/dan/.local/share/nvim/site/pack/packer/opt/elm-vim/ftdetect/elm.vim]]
time([[Sourcing ftdetect script at: /home/dan/.local/share/nvim/site/pack/packer/opt/elm-vim/ftdetect/elm.vim]], false)
time([[Sourcing ftdetect script at: /home/dan/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/cls.vim]], true)
vim.cmd [[source /home/dan/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/cls.vim]]
time([[Sourcing ftdetect script at: /home/dan/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/cls.vim]], false)
time([[Sourcing ftdetect script at: /home/dan/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tex.vim]], true)
vim.cmd [[source /home/dan/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tex.vim]]
time([[Sourcing ftdetect script at: /home/dan/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tex.vim]], false)
time([[Sourcing ftdetect script at: /home/dan/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tikz.vim]], true)
vim.cmd [[source /home/dan/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tikz.vim]]
time([[Sourcing ftdetect script at: /home/dan/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tikz.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles(0) end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
