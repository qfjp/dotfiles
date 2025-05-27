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
    { "mhinz/vim-startify", dependencies = { "ryanoasis/vim-devicons", }, },
    { "lewis6991/impatient.nvim", priority = 1000, },

    -- Fennel
    { "gpanders/nvim-parinfer", ft = { "clojure", "fennel", "scheme", "lisp" }, },
    { "mnacamura/vim-fennel-syntax", ft = "fennel", },
    -- Vim Essentials

    { "mbbill/undotree", cmd = "UndotreeShow", },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = require("lualine_conf").lualine_conf,
    },
    { "mhinz/vim-sayonara", config = SayoConfig, },
    { "tpope/vim-repeat", },
    { "tpope/vim-surround", },
    { "tpope/vim-speeddating", },
    { "wellle/targets.vim", },
    { "windwp/nvim-autopairs", opts = {}, },

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
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = false,
                lsp_doc_border = false,
            },
            cmdline = { view = "cmdline" },
            messages = {
                enabled = true,
                view = "mini",
                view_warn = "mini",
            },
            nui = { position = "50%" },
        },
    },
    {
        "folke/twilight.nvim",
        --cmd = { 'twilight', 'twilightenable', 'twilightdisable' },
    },
    {
        "junegunn/goyo.vim",
        --cmd = { 'goyo', 'goyoenter', 'goyoleave'},
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
    { "karb94/neoscroll.nvim", opts = neoscroll_conf, },
    {
        "camspiers/lens.vim",
        dependencies = { "camspiers/animate.vim" },
    },
    { "j-hui/fidget.nvim", opts = {}, },
    --  formatting
    { "junegunn/vim-easy-align", },
    { "sbdchd/neoformat", },

    --  Telescope
    {
        "rcarriga/nvim-notify",
        branch = "master",
        opts = {
            background_colour = "#868a75",
            render = "minimal",
        },
    },
    { "vigoux/notifier.nvim", opts = {}, },
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
    { "camilledejoye/nvim-lsp-selection-range", },
    {
        "nvimdev/lspsaga.nvim",
        event = "LspAttach",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        opts = { ui = {code_action = ""} },
    },
    --  LSP Configuration
    { "smjonas/inc-rename.nvim", },
    { "neovim/nvim-lspconfig", },
    { "scalameta/nvim-metals", },
    { "mfussenegger/nvim-jdtls", ft = { "java" }, },
    { "williamboman/mason.nvim", opts = {}, },

    --  Completion/Snippets
    { "hrsh7th/vim-vsnip", },
    { "rafamadriz/friendly-snippets", },
    { "onsails/lspkind.nvim", },

    ----  Browser
    { "subnut/nvim-ghost.nvim", },

    --  Filetypes
    { "tridactyl/vim-tridactyl", ft = { "tridactyl" }, },
    { "lervag/vimtex", ft = { "tex" }, },
    {
        "rbonvall/vim-textobj-latex",
        ft = { "tex" },
        dependencies = { "kana/vim-textobj-user" },
    },
    { "neovimhaskell/haskell-vim", ft = { "haskell" }, },
    { "mattn/emmet-vim", ft = { "html", "xml" }, },
    { "ElmCast/elm-vim", ft = { "html", "xml" }, },
    { "mattly/vim-markdown-enhancements", ft = { "markdown" }, },

    --  Color
    { "mhinz/vim-janah", },
    { "norcalli/nvim-colorizer.lua", opts = {}, },

    --  Tmux
    { "christoomey/vim-tmux-navigator", },
    { "knubie/vim-kitty-navigator", build = "cp ./*.py ~/.config/kitty", },
    { "vimwiki/vimwiki", ft = { "vimwiki" }, },
    { "Feel-ix-343/markdown-oxide", },
}
