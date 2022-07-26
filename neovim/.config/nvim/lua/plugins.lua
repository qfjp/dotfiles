local fn = vim.fn
local conf = fn.stdpath('config') .. '/bundle/'
local plugins = {}
local float_conf = nil
if pcall(require, "packer.util") then
    float_conf = package.loaded["packer.util"].float
end
function SayoConfig()
  vim.api.nvim_create_user_command("S", "Sayonara!", {force = true})
  vim.api.nvim_create_user_command("Sa", "Sayonara", {force = true})
  vim.g.sayonara_confirm_quit = true
  return nil
end

function LuaLineConfig()
    local theme_name = "jellybeans"
    local mod_color = "#aa3355"
    if pcall(require, "lualine") then
      local theme = require("lualine.themes." .. theme_name)
      package.loaded.lualine.setup(
          { options =
              { icons_enabled = true
              , theme = theme_name
              , section_separators = { left = "", right = "" }
              , component_separators = { left = "", right = "" }
              , always_divide_middle = true
              , globalstatus = false
              }
          , sections =
              { lualine_a = {"mode"}
              , lualine_b = {"branch", "diff", "diagnostics"}
              , lualine_c = {{ "filename"
                             , symbols = {modified =" ●", readonly=" "}
                             , color = function(_)
                                 return {fg = vim.bo.modified and mod_color}
                               end
                             }}
              , lualine_x = {"encoding", "fileformat", "filetype"}
              , lualine_y = {"progress"}
              , lualine_z = {"location"}
              }
          , tabline =
              { lualine_a = {
                      { "buffers"
                      , buffers_color =
                          { active = function(_)
                              return
                                { fg = vim.bo.modified and mod_color
                                , bg = theme.normal.a.bg
                                }
                            end
                          }
                      }
                }
              , lualine_b = {}
              , lualine_c = {}
              , lualine_x = {}
              , lualine_y = {}
              , lualine_z = {"tabs"}
              }
          , inactive_sections =
              { lualine_a = {}
              , lualine_b = {}
              , lualine_c = {"branch", {"filename", symbols = {modified =" ●", readonly=" "}}}
              , lualine_x = {"location"}
              , lualine_y = {}
              , lualine_z = {}
              }
          , extensions = {}
          }
      )
    end
end

function SafeRequire(module, opts)
    if pcall(require, module) then
        package.loaded[module].setup(opts)
    end
end

plugins.packer_table = {function(use)
    -- Startup
    use 'lewis6991/impatient.nvim'
    use 'wbthomason/packer.nvim'

    -- pathogen replacement
    use 'qfjp/AnsiEsc'
    use (conf .. 'SyntaxAttr')
    use (conf .. 'vim-haskellConcealPlus')

    -- Fennel
    use { 'eraserhd/parinfer-rust'
        , ft = {'clojure', 'fennel', 'lisp', 'scheme'}
        , run = 'cargo build --release'
    }
    use {'p00f/nvim-ts-rainbow'}
    use {'mnacamura/vim-fennel-syntax', ft='fennel'}
    use {'Olical/conjure'}
    use {'rktjmp/hotpot.nvim'}
    use {"tsbohc/zest.nvim", config = SafeRequire("zest", {})}

    -- Vim Essentials
    use {'mbbill/undotree', cmd = 'UndotreeToggle'}
    use { 'nvim-lualine/lualine.nvim'
        , requires = {'kyazdani42/nvim-web-devicons', opt=true}
        , configure = LuaLineConfig()
        }
    use {'mhinz/vim-startify', requires = 'ryanoasis/vim-devicons'}
    use { 'mhinz/vim-sayonara'
        , config = SayoConfig
        }
    use 'tpope/vim-repeat'
    use 'tpope/vim-surround'
    use 'tpope/vim-speeddating'
    use 'wellle/targets.vim'
    use { 'windwp/nvim-autopairs'
        , config = SafeRequire("nvim-autopairs", {})
        }

    -- Git
    use { 'lewis6991/gitsigns.nvim'
        , config = SafeRequire("gitsigns", require("gitsigns_config"))}
    use { 'TimUntersberger/neogit'
        , config = SafeRequire("neogit", {})
        , requires = "nvim-lua/plenary.nvim"
        }

    -- Motions
    use 'ggandor/lightspeed.nvim'
    use 'sjbach/Lusty'

    -- Highfalutin n' Fancy
    use {'folke/twilight.nvim', cmd = {'Twilight', 'TwilightEnable', 'TwilightDisable'}}
    use {'junegunn/goyo.vim', cmd = {'Goyo', 'GoyoEnter', 'GoyoLeave'}}
    use { 'nvim-treesitter/playground'
        , requires = {'nvim-treesitter/nvim-treesitter'}
        , cmd = {'TSHighlightCapturesUnderCursor', 'TSPlaygroundToggle'}
        , run = ":TSInstall query"
        }
    use 'rinx/nvim-minimap'
    use { 'folke/which-key.nvim'
        , config = SafeRequire("which-key", {})
        }
    use { 'karb94/neoscroll.nvim'
        , config
            = SafeRequire("neoscroll",
                { mappings = {'<C-u>', "<C-d>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb"}
                , hide_cursor = false
                , respect_scrolloff = true
                })
        }
    use {'camspiers/lens.vim', requires = {'camspiers/animate.vim'}}
    use {'j-hui/fidget.nvim', configure = SafeRequire("fidget", {})}
    use { 'norcalli/nvim-colorizer.lua'
        , config = SafeRequire("colorizer")
        }

    -- Formatting
    use 'junegunn/vim-easy-align'
    use {'sbdchd/neoformat', cmd = 'Neoformat', event = 'BufWritePre'}

    -- LSP Configuration
    use 'neovim/nvim-lspconfig'
    use {'scalameta/nvim-metals',ft = {'scala', 'sbt'}}
    use {'mfussenegger/nvim-jdtls', ft = 'java'}
    use {'williamboman/nvim-lsp-installer', requires = {'neovim/nvim-lspconfig'},}

    -- Completion/Snippets
    use 'hrsh7th/vim-vsnip'
    use 'rafamadriz/friendly-snippets'
    use 'onsails/lspkind.nvim'
    use {'hrsh7th/cmp-nvim-lua', ft = {'vim', 'lua'}}
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-vsnip'
    use {'f3fora/cmp-spell', ft = 'tex'}
    use { 'uga-rosa/cmp-dictionary'
        , ft = 'tex'
        , config
            = SafeRequire( "cmp_dictionary"
                         , { dic = { ["*"] = { '/usr/share/hunspell/en_US.dic' }
                                   , spellang = { en = '/usr/share/hunspell/en_US.dic' }
                                   }
                           , exact = 2
                           , first_case_insensitive = false
                           , document = false
                           , document_command = 'wn %s -over'
                           , async = true
                           , capacity = 5
                           , debug = false
                           }
                         )
        }
    use {'kdheepak/cmp-latex-symbols', ft = 'tex'}
    use 'max397574/cmp-greek'

    -- Filetypes
    use {'lervag/vimtex', ft = 'tex'}
    use {'rbonvall/vim-textobj-latex', ft = 'tex', requires = 'kana/vim-textobj-user'}
    use {'neovimhaskell/haskell-vim', ft = 'haskell'}
    use {'mattn/emmet-vim', ft = {'html', 'xml'}}
    use {'ElmCast/elm-vim', ft = {'html', 'xml'}}
    use {'mattly/vim-markdown-enhancements', ft = 'markdown'}

    -- Color
    use 'mhinz/vim-janah'

    -- Tmux
    use {'christoomey/vim-tmux-navigator'}

    -- Categories?
    use {'vimwiki/vimwiki', ft = 'vimwiki'}
  end,
  config = {
    display = {
      open_fn = float_conf,
    },
    profile = {
      enable = true,
      threshold = 0.1,
    },
  }
}
return plugins
