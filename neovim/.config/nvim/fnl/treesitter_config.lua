" {{{ Treesitter
" --------------
    lua << EOF
    require'nvim-treesitter.configs'.setup {
        ensure_installed = {"c", "lua", "haskell", "scala", "vim", "json", "bash", "latex", "make", "python", 'java'},
        sync_install = false,
        highlight = {
            enable = true,
            disable = {"scala"},
        --    additional_vim_regex_highlighting = {"scala"},
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
EOF
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
" }}}
