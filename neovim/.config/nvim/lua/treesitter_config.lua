-- {{{ Treesitter
-- --------------
    local enabled_list = {'clojure', 'fennel', 'commonlisp', 'scheme'}
    local parsers = require('nvim-treesitter.parsers')
    require'nvim-treesitter.configs'.setup {
        ensure_installed =
          { "bash"
          , "c"
          , "clojure"
          , "commonlisp"
          , "fennel"
          , "haskell"
          , "java"
          , "json"
          , "latex"
          , "lua"
          , "make"
          , "python"
          , "query"
          , "scala"
          , "scheme"
          , "vim"
        },
        sync_install = false,
        highlight = {
            enable = true,
            disable = {"scala"},
        --    additional_vim_regex_highlighting = {"scala"},
        },
        rainbow = {
            enable = true,
            max_file_lines = nil,
            disable = vim.tbl_filter(
              function(p)
                local disable = true
                for _, lang in pairs(enabled_list) do
                    if p == lang then disable = false end
                end
                return disable
              end,
              parsers.available_parsers()
            ),
            colors = {
              "#f4bf75",
              "#989892",
              "#a6e22e",
              "#66d9ef",
              "#ae81ff",
              "#a1efe4",
              "#f9f8f5",
              "#f92672",
            },
            termcolors = {
              "Yellow",
              "Grey",
              "LightGreen",
              "43",
              "57",
              "109",
              "White",
              "Red",
            },
        },
        indent = {
            enable = true,
        },
        incremental_selection = {
            enable = false,
            keymaps = {
                init_selection = '<BACKSPACE>',
                scope_incremental = '<BACKSPACE>',
                node_incremental = '<TAB>',
                node_decremental = '<S-TAB>'
            },
        },
        playground = {
            enable = true,
            disable = {},
            updatetime = 25,
            persist_queries = false,
            keybindings = {
                toggle_query_editor = 'o',
                toggle_hi_groups = 'i',
                toggle_injected_languages = 't',
                toggle_anonymous_nodes = 'a',
                toggle_language_display = 'I',
                focus_language = 'f',
                unfocus_language = 'F',
                update = 'R',
                goto_node = '<cr>',
                show_help = '?',
            },
        },
    }
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- }}}
