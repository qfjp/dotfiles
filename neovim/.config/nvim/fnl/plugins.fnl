(import-macros my-macros :macros)
(local conf (.. (my-macros.vimfn stdpath :config) :/bundle/))
(local plugins {})

(fn SayoConfig []
  (my-macros.exec [[command! S Sayonara] [command! Sa Sayonara]])
  (my-macros.g! sayonara_confirm_quit true))

(local lualine-conf (. (require :lualine-conf) :lualine-conf))
(local cmpdict-conf (. (require :completion_config) :cmpdict_conf))

(fn SafeRequire [mod opts]
  (when (pcall require mod)
    ((. (. package.loaded mod) :setup) opts)))

(local neoscroll_conf {:mappings [:<C-u>
                                  :<C-d>
                                  :<C-f>
                                  :<C-y>
                                  :<C-e>
                                  :zt
                                  :zz
                                  :zb]
                       :hide_cursor false
                       :respect_scrolloff true})

(local packer-opts {:config {:display {:open_fn (. (require :packer.util)
                                                   :float)}}
                    :profile {:enable true :threshold 0.1}})

(local packer-fn
       (my-macros.packer! {;;startup
                           :lewis6991/impatient.nvim []
                           :wbthomason/packer.nvim []
                           ;; personal
                           :qfjp/AnsiEsc []
                           :qfjp/silverscreen.nvim {:requires [:rktjmp/lush.nvim]}
                           (.. conf :SyntaxAttr) []
                           (.. conf :vim-haskellConcealPlus) []
                           ;; Fennel
                           :gpanders/nvim-parinfer {:ft [:clojure
                                                         :fennel
                                                         :scheme
                                                         :lisp]}
                           :p00f/nvim-ts-rainbow []
                           :mnacamura/vim-fennel-syntax {:ft :fennel}
                           :rktjmp/hotpot.nvim []
                           :katawful/katcros-fnl {}
                           ;; Vim Essentials
                           :mbbill/undotree {:cmd :UndoTreeToggle}
                           :nvim-lualine/lualine.nvim {:requires {1 :nvim-tree/nvim-web-devicons
                                                                  :opt true}
                                                       :config (when (pcall require
                                                                            :lualine)
                                                                 ((. (require :lualine)
                                                                     :setup) lualine-conf))}
                           :mhinz/vim-startify {:requires :ryanoasis/vim-devicons}
                           :mhinz/vim-sayonara {:config SayoConfig}
                           :tpope/vim-repeat []
                           :tpope/vim-surround []
                           :tpope/vim-speeddating []
                           :wellle/targets.vim []
                           :windwp/nvim-autopairs {:config (SafeRequire :nvim-autopairs
                                                                        [])}
                           ;; Git
                           :lewis6991/gitsigns.nvim {:config (SafeRequire :gitsigns
                                                                          (. (require :gitsigns_config)
                                                                             :git_sign_table))}
                           :NeogitOrg/neogit {:config (SafeRequire :neogit [])
                                              :requires [:nvim-lua/plenary.nvim
                                                         :nvim-telescope/telescope.nvim
                                                         :sindrets/diffview.nvim]}
                           ;; Motions
                           :ggandor/lightspeed.nvim []
                           :sjbach/Lusty []
                           ;; Highfalutin n' Fancy
                           :xiyaowong/transparent.nvim []
                           :folke/twilight.nvim {:cmd :Twilight
                                                 :TwilightEnable :TwilightDisable}
                           :junegunn/goyo.vim {:cmd :Goyo
                                               :GoyoEnter :GoyoLeave}
                           :nvim-treesitter/playground {:requires :nvim-treesitter/nvim-treesitter}
                           :Olical/conjure []
                           :rinx/nvim-minimap []
                           :nvim-tree/nvim-web-devicons []
                           :folke/which-key.nvim {:config (SafeRequire :which-key
                                                                       {})
                                                  :requires {1 :nvim-tree/nvim-web-devicons
                                                             2 :echasnovski/mini.icons}}
                           :karb94/neoscroll.nvim {:config (SafeRequire :neoscroll
                                                                        neoscroll_conf)}
                           :camspiers/lens.vim {:requires [:camspiers/animate.vim]}
                           :j-hui/fidget.nvim {:config (SafeRequire :fidget {})
                                               :tag :legacy}
                           ;; Formatting
                           :junegunn/vim-easy-align []
                           :sbdchd/neoformat []
                           ;; Telescope
                           :rcarriga/nvim-notify {:branch :master}
                           ;;;; create notifications with
                           ;;;; lua> require("notify").notify("Hello, World!")
                           :vigoux/notifier.nvim {:config (SafeRequire :notifier
                                                                       {})}
                           ;;;; create notifications with
                           ;;;; lua> require("notifier").notify("Hello, World!")
                           :nvim-telescope/telescope.nvim {:requires [:BurntSushi/ripgrep
                                                                      :nvim-lua/plenary.nvim
                                                                      :nvim-telescope/telescope-fzy-native.nvim
                                                                      :nvim-telescope/telescope-packer.nvim
                                                                      :zschreur/telescope-jj.nvim
                                                                      :gbirke/telescope-foldmarkers.nvim
                                                                      :OliverChao/telescope-picker-list.nvim
                                                                      :cagve/telescope-texsuite
                                                                      :lpoto/telescope-docker.nvim
                                                                      :debugloop/telescope-undo.nvim
                                                                      :LinArcX/telescope-ports.nvim
                                                                      :olacin/telescope-cc.nvim
                                                                      :gbrlsnchs/telescope-lsp-handlers.nvim
                                                                      :mrcjkb/haskell-tools.nvim]}
                           :kevinhwang91/nvim-ufo {:requires :kevinhwang91/promise-async}
                           :camilledejoye/nvim-lsp-selection-range {}
                           :nvimdev/lspsaga.nvim {:after :nvim-lspconfig
                                                  :config (SafeRequire :lspsaga
                                                                       {})}
                           ;; LSP Configuration
                           :neovim/nvim-lspconfig []
                           :scalameta/nvim-metals []
                           :mfussenegger/nvim-jdtls {:ft :java}
                           :williamboman/mason.nvim {:config (SafeRequire :mason
                                                                          [])}
                           ;; Completion/Snippets
                           :hrsh7th/vim-vsnip []
                           :rafamadriz/friendly-snippets []
                           :onsails/lspkind.nvim []
                           :hrsh7th/cmp-nvim-lua {:ft [:vim :lua]}
                           :hrsh7th/cmp-nvim-lsp []
                           :hrsh7th/cmp-nvim-lsp-signature-help []
                           :hrsh7th/cmp-buffer []
                           :hrsh7th/cmp-path []
                           :hrsh7th/cmp-cmdline []
                           :hrsh7th/nvim-cmp []
                           :hrsh7th/cmp-vsnip []
                           :PaterJason/cmp-conjure []
                           :f3fora/cmp-spell {:ft [:tex]}
                           :uga-rosa/cmp-dictionary {:ft [:tex
                                                          :config
                                                          (SafeRequire :cmp_dictionary
                                                                       cmpdict-conf)]}
                           :kdheepak/cmp-latex-symbols {:ft [:tex]}
                           :max397574/cmp-greek []
                           ;; Filetypes
                           :tridactyl/vim-tridactyl [:ft tridactyl]
                           :lervag/vimtex {:ft :tex}
                           :rbonvall/vim-textobj-latex {:ft :tex
                                                        :requires :kana/vim-textobj-user}
                           :neovimhaskell/haskell-vim {:ft [:haskell]}
                           :mattn/emmet-vim {:ft [:html :xml]}
                           :ElmCast/elm-vim {:ft [:html :xml]}
                           :mattly/vim-markdown-enhancements {:ft [:markdown]}
                           ;; Color
                           :mhinz/vim-janah []
                           :norcalli/nvim-colorizer.lua {:config (SafeRequire :colorizer)}
                           ;; Tmux
                           :christoomey/vim-tmux-navigator []
                           :vimwiki/vimwiki {:ft [:vimwiki]}
                           :Feel-ix-343/markdown-oxide {}}))

{:packer_table [packer-fn packer-opts]}

