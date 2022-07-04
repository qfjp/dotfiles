" {{{ Completion
" -------------

    " Better display for messages
    set cmdheight=2

    " don't give |ins-completion-menu| messages.
    "set shortmess+=c
    "set completeopt-=preview
    set completeopt=menu,menuone,noselect

    set signcolumn=auto

    nnoremap <silent> gdf <cmd>lua vim.diagnostic.open_float()<CR>
    nnoremap <silent> gdn <cmd>lua vim.diagnostic.goto_next()<CR>
    nnoremap <silent> gdp <cmd>lua vim.diagnostic.goto_prev()<CR>
    nnoremap <silent> gdh <cmd>lua vim.diagnostic.hide()<CR>
    nnoremap <silent> gds <cmd>lua vim.diagnostic.show()<CR>

    sign define DiagnosticSignError text=● texthl=DiagnosticSignError
    sign define DiagnosticSignWarn  text=● texthl=DiagnosticSignWarn
    sign define DiagnosticSignInfo  text=● texthl=DiagnosticSignInfo
    sign define DiagnosticSignHint  text=● texthl=DiagnosticSignHint
    augroup ColorSchemeLspMod
        autocmd!
        autocmd ColorScheme * highlight DiagnosticSignInfo  guifg=skyblue     guibg=none ctermfg=blue   ctermbg=none
        autocmd ColorScheme * highlight DiagnosticSignWarn  guifg=yellow      guibg=none ctermfg=yellow ctermbg=none
        autocmd ColorScheme * highlight DiagnosticSignError guifg=red         guibg=none ctermfg=red    ctermbg=none
        autocmd ColorScheme * highlight DiagnosticSignHint  guifg=lightgreen  guibg=none ctermfg=green  ctermbg=none
    augroup END

    "set completeopt=noinsert,menuone,noselect
    nnoremap <silent> gs  <cmd>lua vim.lsp.buf.declaration()<CR>
    nnoremap <silent> gd  <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <silent> K   <cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <silent> gD  <cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap <silent> gK  <cmd>lua vim.lsp.buf.signature_help()<CR>
    nnoremap <silent> 1gD <cmd>lua vim.lsp.buf.type_defintion()<CR>
    nnoremap <silent> gk  <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>
    nnoremap <silent> gn  <cmd>lua vim.lsp.buf.formatting()<CR>

    set shortmess-=F

    augroup LspGroup
        autocmd!
        autocmd Filetype python    setlocal omnifunc=v:lua.vim.lsp.omnifunc
        autocmd Filetype vim       setlocal omnifunc=v:lua.vim.lsp.omnifunc
        autocmd Filetype haskell   setlocal omnifunc=v:lua.vim.lsp.omnifunc
        autocmd FileType scala,sbt setlocal omnifunc=v:lua.vim.lsp.omnifunc
        autocmd Filetype tex       setlocal omnifunc=v:lua.vim.lsp.omnifunc
        autocmd Filetype json      setlocal omnifunc=v:lua.vim.lsp.omnifunc
    augroup END


    lua << EOF
    -- unicode geo shapes
    -- ◺◹ ◸◿  ◣◥ ◤◢  ◟◝ ◜◞
    vim.g.coq_settings = {
        auto_start = "shut-up",
        keymap = { jump_to_mark = "<c-y>" },
        display = {
            pum = {
                --kind_context =  {" [", "]"},
                --source_context = {"「", "」"},
                --kind_context =  {" ◺", "◹"},
                --source_context = {" ◣", "◥"},
                kind_context =  {" ", ""},
                source_context = {"::", ""}
            },
            preview = {
                border = "double",
            },
            icons = {
                mode = "short",
            },
        },
    }
    local cmp_group = vim.api.nvim_create_augroup("CmpColors", {clear = true})
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*", group = cmp_group
      , callback = function()
          -- gray
          vim.cmd[[highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080]]
          -- blue
          vim.cmd[[highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6]]
          vim.cmd[[highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6]]
          -- light blue
          vim.cmd[[highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE]]
          vim.cmd[[highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE]]
          vim.cmd[[highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE]]
          -- pink
          vim.cmd[[highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0]]
          vim.cmd[[highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0]]
          -- front
          vim.cmd[[highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4]]
          vim.cmd[[highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4]]
          vim.cmd[[highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4]]
        end
    })
    function DictSetup()
        require('cmp_dictionary').setup({
            dic = {
                ["*"] = { '/usr/share/hunspell/en_US.dic' },
                spellang = {
                    en = '/usr/share/hunspell/en_US.dic'
                }
            },
            exact = 2,
            first_case_insensitive = false,
            document = false,
            document_command = 'wn %s -over',
            async = true,
            capacity = 5,
            debug = false,
        })
    end
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    local lspkind = require'lspkind'
    cmp.setup({
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",
          menu = ({
            buffer = '[Buf]',
            dictionary = '[Dict]',
            latex_symbols = '[LaTeX]',
            nvim_lua = '[Lua]',
            nvim_lsp = '[LSP]',
            path = '[FS]',
            spell = '[Sp]',
            vsnip = '[vsnip]',
          }),
        }),
      },
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
          -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
          -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        end,
      },
      window = {
        -- completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lua' },
        { name = 'vsnip' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'greek' },
      })
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
      }, {
        { name = 'buffer' },
      })
    })

    cmp.setup.filetype('tex', {
      sources = cmp.config.sources({
        { name = 'latex_symbols' }
    }, {
        { name = 'spell' },
    }, {
        { name = 'dictionary' },
      })
    })

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      view = {
        entries = {name = "custom", selection_order = 'near_cursor'},
      },
      sources = {
        { name = 'buffer' }
      }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      view = {
        entries = {name = "custom", selection_order = 'near_cursor'},
      },
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })

    -- Setup lspconfig.
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

    require("nvim-lsp-installer").setup {}
    local lspconfig = require 'lspconfig'
    --local coq = require 'coq'
    lspconfig.bashls.setup{
        cmd = {"bash-language-server", "start"};
        filetypes = {"sh", "bash", "zsh"};
        capabilites = capabilites
    };
    lspconfig.cssls.setup{
        capabilities = capabilites;
        cmd = {"vscode-css-languageserver", "--stdio"};
        filetypes = {"css", "scss", "less"};
        capabilites = capabilites
    }
    lspconfig.sumneko_lua.setup {
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                },
                diagnostics = {
                    globals = { 'vim' },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                    enable = false,
                },
            },
        },
        capabilites = capabilites
    }
    lspconfig.pylsp.setup{
        settings = {
            pyls = {
                plugins = {
                    black = {
                        enabled = true;
                    };
                };
            };
        };
        capabilites = capabilites
    };
    lspconfig.jsonls.setup{
        cmd = {"json-languageserver", "--stdio"};
        capabilites = capabilites
    };
    lspconfig.vimls.setup{
        filetypes = {"vim"};
        cmd = {"vim-language-server", "--stdio"};
        initializationOptions = {
            isNeovim = true;
        };
        capabilites = capabilites
    }
    lspconfig.hls.setup{
        cmd = {"haskell-language-server-wrapper", "--lsp"};
        filetypes = {"haskell", "lhaskell"};
        settings = {
            haskell = {
                formattingProvider = "brittany";
            };
        };
        single_file_support = true;
        capabilites = capabilites
    };
    lspconfig.texlab.setup{
        settings = {
            bibtex = {
                formatting = {
                    lineLength = 80;
                };
            };
            latex = {
                build = {
                    args = {"-outdir", "build", "-pdf", "-interaction=nonstopmode", "-synctex=1"};
                    executable = "latexmk";
                    onSave = true;
                    outputDirectory = "build";
                };
                lint = {
                    onChange = true;
                };
            };
        };
        capabilites = capabilites
    };
EOF
" }}}
