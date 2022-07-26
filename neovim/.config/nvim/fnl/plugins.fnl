(require-macros :macros)
(local conf (.. (vimfn stdpath :config) :/bundle/))
(local plugins {})

(fn SayoConfig []
  (vim.cmd "command! S Sayonara!")
  (vim.cmd "command! Sa Sayonara")
  (g! sayonara_confirm_quit true))

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

(local lualine-conf (let [theme-name :jellybeans
                          mod_color "#aa3355"
                          theme (when (pcall require
                                             (.. :lualine.themes. theme-name))
                                  (require (.. :lualine.themes. theme-name)))
                          theme-bg (when (not (= nil theme))
                                     theme.normal.a.bg)]
                      {:options {:icons_enabled true
                                 :theme theme-name
                                 :section_separators {:left "" :right ""}
                                 :component_separators {:left ""
                                                        :right ""}
                                 :always_divide_middle true
                                 :globalstatus false}
                       :sections {:lualine_a [:mode]
                                  :lualine_b [:branch :diff :diagnostics]
                                  :lualine_c [{1 :filename
                                               :symbols {:modified " ●"
                                                         :readonly " "}
                                               :color (fn [_]
                                                        {:fg (and (bo modified)
                                                                  mod_color)})}]
                                  :lualine_x [:encoding :fileformat :filetype]
                                  :lualine_y [:progress]
                                  :lualine_z [:location]}
                       :tabline {:lualine_a [{1 :buffers
                                              :buffers-color {:active (fn []
                                                                        {:fg (and (bo modified
                                                                                      mod_color))}
                                                                        :bg
                                                                        theme-bg)}}]
                                 :lualine_b []
                                 :lualine_c []
                                 :lualine_x []
                                 :lualine_y []
                                 :lualine_z [:tabs]}
                       :inactive_sections {:lualine_a []
                                           :lualine_b []
                                           :lualine_c [:branch
                                                       {1 :filename
                                                        :symbols {:modified " ●"
                                                                  :readonly " "}}]
                                           :lualine_x [:location]
                                           :lualine_y []
                                           :lualine_z []}
                       :extensions []}))

(local cmpdict_conf {:dic {:* [:/usr/share/hunspell/en_US.dic]
                           :spellang {:en :/usr/share/hunspell/en_US.dic}}
                     :exact 2
                     :first_case_insensitive false
                     :document false
                     :document_command "wn %s -over"
                     :async true
                     :capacity 5
                     :debug false})

(local packer-opts {:config {:display {:open_fn (. (require :packer.util)
                                                   :float)}}
                    :profile {:enable true :threshold 0.1}})

(macro packer! [packer-tab packer-opts]
  (let [result {}
        opt-keys [:disable
                  :as
                  :installer
                  :updater
                  :after
                  :rtp
                  :opt
                  :branch
                  :tag
                  :commit
                  :lock
                  :run
                  :requires
                  :rocks
                  :config
                  :setup
                  :cmd
                  :ft
                  :keys
                  :event
                  :fn
                  :cond
                  :module
                  :module_pattern]]
    (each [plug opts (pairs packer-tab)]
      (let [this-result {1 plug}]
        (each [_ opt-key (ipairs opt-keys)]
          (tset this-result opt-key (. opts opt-key)))
        (tset result (+ 1 (length result)) `(use ,this-result))))
    result))

(local packer-fn
       (fn [use]
         (packer! {;;startup
                   :lewis6991/impatient.nvim []
                   :wbthomason/packer.nvim []
                   ;; personal
                   :qfjp/AnsiEsc []
                   (.. conf :SyntaxAttr) []
                   (.. conf :vim-haskellConcealPlus) []
                   ;; Fennel
                   :gpanders/nvim-parinfer {:ft [:clojure
                                                 :fennel
                                                 :scheme
                                                 :lisp]}
                   :p00f/nvim-ts-rainbow []
                   :mnacamura/vim-fennel-syntax {:ft :fennel}
                   :Olical/conjure []
                   :rktjmp/hotpot.nvim []
                   :tsbohc/zest.nvim [:config ((. (require :zest) :setup))]
                   ;; Vim Essentials
                   :mbbill/undotree {:cmd :UndoTreeToggle}
                   :nvim-lualine/lualine.nvim {:requires {1 :kyazdani42/nvim-web-devicons
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
                                                                  (require :gitsigns_config))}
                   :TimUntersberger/neogit {:config (SafeRequire :neogit [])
                                            :requires :nvim-lua/plenary.nvim}
                   ;; Motions
                   :ggandor/lightspeed.nvim []
                   :sjbach/Lusty []
                   ;; Highfalutin n' Fancy
                   :folke/twilight.nvim {:cmd :Twilight
                                         :TwilightEnable :TwilightDisable}
                   :junegunn/goyo.vim {:cmd :Goyo :GoyoEnter :GoyoLeave}
                   :nvim-treesitter/playground {:requires :nvim-treesitter/nvim-treesitter
                                                :run (fn []
                                                       (when (and (pcall require
                                                                         :cmp)
                                                                  (pcall require
                                                                         :nvim-treesitter))
                                                         (vim.cmd "TSInstall query")))}
                   :rinx/nvim-minimap []
                   :folke/which-key.nvim {:config (SafeRequire :which-key {})}
                   :karb94/neoscroll.nvim {:config (SafeRequire :neoscroll
                                                                neoscroll_conf)}
                   :camspiers/lens.vim {:requires [:camspiers/animate.vim]}
                   :j-hui/fidget.nvim {:config (SafeRequire :fidget {})}
                   ;; Formatting
                   :junegunn/vim-easy-align []
                   :sbdchd/neoformat []
                   ;; LSP Configuration
                   :neovim/nvim-lspconfig []
                   :scalameta/nvim-metals {:ft [:scala :sbt]}
                   :mfussenegger/nvim-jdtls {:ft :java}
                   :williamboman/nvim-lsp-installer {:requires [:neovim/nvim-lspconfig]}
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
                   :f3fora/cmp-spell {:ft [:tex]}
                   :uga-rosa/cmp-dictionary {:ft [:tex
                                                  :config
                                                  (SafeRequire :cmp_dictionary
                                                               cmpdict_conf)]}
                   :kdheepak/cmp-latex-symbols {:ft [:tex]}
                   :max397574/cmp-greek []
                   ;; Filetypes
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
                   :vimwiki/vimwiki {:ft [:vimwiki]}})))

{:packer_table [packer-fn packer-opts]}

