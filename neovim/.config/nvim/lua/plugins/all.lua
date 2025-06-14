function SayoConfig()
    vim.cmd([[command! S Sayonara]])
    vim.cmd([[command! Sa Sayonara]])
    vim.g.sayonara_confirm_quit = true
end

local neoscroll_conf = {
    mappings = {
        "<C-u>",
        "<C-d>",
        "<C-f>",
        "<C-y>",
        "<C-e>",
        "zt",
        "zz",
        "zb",
    },
    hide_cursor = false,
    respect_scrolloff = true,
}

return {

    -- personal
    {
        "qfjp/silverscreen.nvim",
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme silverscreen]])
        end,
        dependencies = {
            "rktjmp/lush.nvim",
        },
    },
    { "qfjp/AnsiEsc" },
    { dir = "~/.config/nvim/bundle/vim-haskellConcealPlus", },
    { dir = "~/.config/nvim/bundle/SyntaxAttr", },

    -- startup
    { "mhinz/vim-startify",                                 dependencies = { "ryanoasis/vim-devicons", }, },
    { "lewis6991/impatient.nvim",                           priority = 1000, },

    -- Fennel
    { "gpanders/nvim-parinfer",                             ft = { "clojure", "fennel", "scheme", "lisp" }, },
    { "mnacamura/vim-fennel-syntax",                        ft = "fennel", },
    -- Vim Essentials

    { "mbbill/undotree",                                    cmd = "UndotreeShow", },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = require("lualine_conf").lualine_conf,
    },
    { "mhinz/vim-sayonara",      config = SayoConfig, },
    { "tpope/vim-repeat", },
    { "tpope/vim-surround", },
    { "tpope/vim-speeddating", },
    { "wellle/targets.vim", },
    { "windwp/nvim-autopairs",   opts = {}, },

    --  Git
    { "lewis6991/gitsigns.nvim", opts = require("gitsigns_config").git_sign_table, },
    {
        "NeogitOrg/neogit",
        opts = { graph_style = "kitty" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "sindrets/diffview.nvim",
        },
    },
    --  motions
    { "ggandor/lightspeed.nvim", },
    { 'sjbach/lusty', },
    {
        "leonheidelbach/trailblazer.nvim",
        opts = {
            auto_save_trailblazer_state_on_exit = true,
            auto_load_trailblazer_state_on_enter = true,
            current_trail_mark_stack_sort_mode = "chron_dsc",
        },
    },
    -- highfalutin n' fancy
    {
        "folke/noice.nvim",
        dependencies = {
            "rcarriga/nvim-notify",
            "MunifTanjim/nui.nvim",
        },
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                },
                signature = {
                    enabled = false,
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = false,
                lsp_doc_border = true,
            },
            cmdline = { view = "cmdline" },
            messages = {
                enabled = true,
                view = "mini",
                view_warn = "mini",
            },
            popupmenu = {
                enabled = false
            },
            nui = { position = "50%" },
        },
    },
    {
        "folke/twilight.nvim",
        cmd = {
            'Twilight',
            'TwilightEnable',
            'TwilightDisable'
        },
    },
    {
        "junegunn/goyo.vim",
        cmd = { 'Goyo', },
    },
    {
        "nvim-treesitter/playground",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    { "olical/conjure", },
    { "nvim-tree/nvim-web-devicons", },
    {
        "folke/which-key.nvim",
        opts = {},
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "echasnovski/mini.icons",
        },
    },
    { "karb94/neoscroll.nvim",   opts = neoscroll_conf, },
    {
        "camspiers/lens.vim",
        dependencies = { "camspiers/animate.vim" },
    },
    { "j-hui/fidget.nvim",       opts = {}, },
    --  formatting
    { "junegunn/vim-easy-align", },

    --  Telescope
    {
        "rcarriga/nvim-notify",
        branch = "master",
        opts = {
            background_colour = "#868a75",
            render = "minimal",
        },
    },
    { "vigoux/notifier.nvim",    opts = {}, },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "BurntSushi/ripgrep",
            "tpope/vim-fugitive",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzy-native.nvim",
            "zschreur/telescope-jj.nvim",
            "gbirke/telescope-foldmarkers.nvim",
            "OliverChao/telescope-picker-list.nvim",
            "cagve/telescope-texsuite",
            "lpoto/telescope-docker.nvim",
            "debugloop/telescope-undo.nvim",
            "LinArcX/telescope-ports.nvim",
            "olacin/telescope-cc.nvim",
            "gbrlsnchs/telescope-lsp-handlers.nvim",
            "mrcjkb/haskell-tools.nvim",
        },
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
    },
    {
        "nvimdev/lspsaga.nvim",
        event = "LspAttach",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        opts = {
            symbol_in_winbar = {
                separator = '  ',  -- ' › '
                show_file = false,
                color_mode = false,
            },
            ui = { code_action = "", },
        },
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "InsertEnter",
        opts = {
            bind = true,
            handler_opts = {
                border = "rounded"
            }
        },
        -- or use config
        -- config = function(_, opts) require'lsp_signature'.setup({you options}) end
    },
    --  LSP Configuration
    { "smjonas/inc-rename.nvim", },
    {
        "neovim/nvim-lspconfig",
        lazy = false, -- REQUIRED: tell lazy.nvim to start this plugin at startup
        dependencies = {
            -- main one
            { "ms-jpq/coq_nvim",       branch = "coq" },

            -- 9000+ Snippets
            { "ms-jpq/coq.artifacts",  branch = "artifacts" },

            -- lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
            -- Need to **configure separately**
            { 'ms-jpq/coq.thirdparty', branch = "3p" }
            -- - shell repl
            -- - nvim lua api
            -- - scientific calculator
            -- - comment banner
            -- - etc
        },
        init = function()
            vim.g.coq_settings = {
                auto_start = true, -- if you want to start COQ at startup
                -- Your COQ settings here
                keymap = {
                    recommended = false,
                    jump_to_mark = '',
                    manual_complete = '<c-n>',
                    manual_complete_insertion_only = true,
                },
                completion = {
                    always = true,
                },
                display = {
                    pum = {
                        y_ratio = 0.2,
                        kind_context = { " [", "]" },
                        source_context = { "「", "」" },
                    },
                },
            }
        end,
        config = function()
			vim.api.nvim_set_keymap('i', '<C-c>', [[pumvisible() ? "\<C-e><C-c>" : "\<C-c>"]], { expr = true, silent = true })
			vim.api.nvim_set_keymap('i', '<BS>', [[pumvisible() ? "\<C-e><BS>" : "\<BS>"]], { expr = true, silent = true })
            vim.api.nvim_set_keymap(
                "i",
                "<Esc>",
                [[pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<Esc>"]],
                { expr = true, silent = true }
            )
			vim.api.nvim_set_keymap('i', '<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true, silent = true })
			vim.api.nvim_set_keymap('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<BS>"]], { expr = true, silent = true })

            require("completion_config")
            if pcall(require, "coq_3p") then
                require("coq_3p") {
                    { src = "nvimlua",        short_name = "nLUA", conf_only = false },
                    { src = "vimtex",         short_name = "vTEX" },
                    { src = "builtin/c" },
                    { src = "builtin/css" },
                    { src = "builtin/haskell" },
                    { src = "builtin/html" },
                    { src = "builtin/js" },
                    { src = "builtin/syntax" },
                    { src = "builtin/xml" },
                    { src = "bc",             short_name = "MATH", precision = 6 },
                    { src = "cow",            trigger = "!cow" },
                }
            end
        end,
    },
    { "scalameta/nvim-metals", },
    { "mfussenegger/nvim-jdtls", ft = { "java" }, },
    { "williamboman/mason.nvim", opts = {}, },

    ----  Browser
    { "subnut/nvim-ghost.nvim", },

    --  Filetypes
    { "tridactyl/vim-tridactyl", ft = { "tridactyl" }, },
    { "lervag/vimtex",           ft = { "tex" }, },
    {
        "rbonvall/vim-textobj-latex",
        ft = { "tex" },
        dependencies = { "kana/vim-textobj-user" },
    },
    {
        "kana/vim-textobj-user",
    },
    { "neovimhaskell/haskell-vim",        ft = { "haskell" }, },
    { "mattn/emmet-vim",                  ft = { "html", "xml" }, },
    { "ElmCast/elm-vim",                  ft = { "html", "xml" }, },
    { "mattly/vim-markdown-enhancements", ft = { "markdown" }, },

    --  Color
    { "mhinz/vim-janah", },
    { "norcalli/nvim-colorizer.lua",      opts = {}, },

    --  Tmux
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
            "TmuxNavigatorProcessList",
        },
    },
    {
        "knubie/vim-kitty-navigator",
        build = "cp ./*.py ~/.config/kitty",
        cmd = {
            "KittyNavigateLeft",
            "KittyNavigateDown",
            "KittyNavigateUp",
            "KittyNavigateRight",
        }
    },
    { "vimwiki/vimwiki",            ft = { "vimwiki" }, },
    { "Feel-ix-343/markdown-oxide", },
}
