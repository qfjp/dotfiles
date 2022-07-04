local fn = vim.fn
local conf = fn.stdpath('config') .. '/bundle/'

-- bootstrap fnl
local hotpot_path = fn.stdpath('data') .. '/site/pack/packer/start/hotpot.nvim'
if fn.empty(fn.glob(hotpot_path)) > 0 then
    fn.system({'git', 'clone', 'https://github.com/rktjmp/hotpot.nvim', hotpot_path})
    vim.cmd('helptags ' .. hotpot_path .. '/doc')
end
require('hotpot')

-- bootstrap packer
local packer_install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(packer_install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', packer_install_path})
end

return require('packer').startup({function(use)
    -- Startup
    use 'famiu/nvim-reload'
    use 'lewis6991/impatient.nvim'
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'

    -- pathogen replacement
    use (conf .. 'AnsiEsc')
    use (conf .. 'SyntaxAttr')
    use (conf .. 'vim-haskellConcealPlus')

    -- Fennel
    use {'eraserhd/parinfer-rust'
        ,ft = {'clojure', 'fennel', 'lisp', 'scheme'}
        ,run = 'cargo build --release'
        }
    use {'mnacamura/vim-fennel-syntax', ft='fennel'}
    use {'Olical/conjure'}
    use {'rktjmp/hotpot.nvim'}
    use {'tsbohc/zest.nvim', config = function() require('zest').setup() end}

    -- Vim Essentials
    use {'mbbill/undotree', cmd = 'UndotreeToggle'}
    use {'mengelbrecht/lightline-bufferline'
        ,requires = {{'itchyny/lightline.vim'}, {'ryanoasis/vim-devicons'}}
        }
    use 'mhinz/vim-startify'
    use {'mhinz/vim-sayonara', cmd = {'Sayonara', 'Sayonara!', 'S', 'Sa'}
        ,config = SayoConfig
        }
    use 'tpope/vim-repeat'
    use 'tpope/vim-surround'
    use 'tpope/vim-speeddating'
    use {'tpope/vim-obsession'
        ,cmd = {'Obsess', 'SSave', 'SLoad', 'SClose', 'SDelete', 'mksession'}
        }
    use 'wellle/targets.vim'
    use {'windwp/nvim-autopairs', config = function() require('nvim-autopairs').setup {} end}

    -- Git
    use 'lewis6991/gitsigns.nvim'
    use 'tpope/vim-fugitive'

    -- Motions
    use 'ggandor/lightspeed.nvim'
    use 'sjbach/Lusty'

    -- Highfalutin n' Fancy
    use {'folke/twilight.nvim', cmd = {'Twilight', 'TwilightEnable', 'TwilightDisable'}}
    use {'junegunn/goyo.vim', cmd = {'Goyo', 'GoyoEnter', 'GoyoLeave'}}
    use 'kovetskiy/vim-autoresize'
    use {'nvim-treesitter/playground'
        ,requires = {'nvim-treesitter/nvim-treesitter', opt = true}
        ,cmd = {'TSHighlightCapturesUnderCursor', 'TSPlaygroundToggle'}
        ,run = ":TSInstall query"
        }
    use 'rinx/nvim-minimap'
    use 'urbainvaes/vim-remembrall'

    -- Formatting
    use 'junegunn/vim-easy-align'
    use {'sbdchd/neoformat', cmd = 'Neoformat', event = 'BufWritePre'}

    -- LSP Configuration
    use 'neovim/nvim-lspconfig'
    use {'scalameta/nvim-metals',ft = {'scala', 'sbt'},config = ScalaSetup}
    use {'mfussenegger/nvim-jdtls', ft = 'java', config = JavaSetup}
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
    use {'uga-rosa/cmp-dictionary', ft = 'tex', config = DictSetup}
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
    use {'christoomey/vim-tmux-navigator', config = TmuxNavConfig}
    --use 'vimpostor/vim-tpipeline'

    -- Categories?
    --use {'rliang/termedit.nvim', cmd = 'terminal'}
    --use 'Shougo/deol.nvim'
    use {'vimwiki/vimwiki', ft = 'vimwiki'}

    if PACKER_BOOTSTRAP then
        require('packer').sync()
    end
  end,
  config = {
    display = {
      open_fn = require('packer.util').float,
    },
    profile = {
      enable = true,
      threshold = 0.1,
    },
  }
})
