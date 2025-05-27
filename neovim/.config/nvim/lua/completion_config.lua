-- {{{ Completion
-- -------------

-- Better display for messages
vim.opt.cmdheight = 2
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.signcolumn = "auto"
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "●",
            [vim.diagnostic.severity.WARN] = "●",
            [vim.diagnostic.severity.HINT] = "●",
            [vim.diagnostic.severity.INFO] = "●",
        },
    },
})

local colorSchemeLsp = vim.api.nvim_create_augroup("ColorSchemeLspMod", { clear = true })
vim.api.nvim_create_autocmd({"ColorScheme"},
    {
        group = colorSchemeLsp,
        nested = false,
        once = false,
        pattern = "*",
        callback = function()
            vim.cmd [[highlight! link DiagnosticInfo ModeMsg]]
            vim.cmd [[highlight! link DiagnosticWarn WarningMsg]]
            vim.cmd [[highlight! link DiagnosticError DiffDelete]]
            vim.cmd [[highlight! link DiagnosticHint DiffAdd]]
            vim.cmd [[highlight! link DiagnosticSignInfo ModeMsg]]
            vim.cmd [[highlight! link DiagnosticSignWarn WarningMsg]]
            vim.cmd [[highlight! link DiagnosticSignError DiffDelete]]
            vim.cmd [[highlight! link DiagnosticSignHint DiffAdd]]
            vim.cmd [[highlight! link DiagnosticVirtualTextInfo DiagnosticSignInfo]]
            vim.cmd [[highlight! link DiagnosticVirtualTextWarn DiagnosticSignWarn]]
            vim.cmd [[highlight! link DiagnosticVirtualTextError DiagnosticSignError]]
            vim.cmd [[highlight! link DiagnosticVirtualTextHint DiagnosticSignHint]]
            vim.cmd [[highlight! lualine_x_diagnostics_error_terminal guifg=#B66A5f guibg=#868383]]
            vim.cmd [[highlight! lualine_x_diagnostics_error_inactive guifg=#B66A5f guibg=#868383]]
            vim.cmd [[highlight! lualine_x_diagnostics_error_replace guifg=#B66A5f guibg=#868383]]
            vim.cmd [[highlight! lualine_x_diagnostics_error_command guifg=#B66A5f guibg=#868383]]
            vim.cmd [[highlight! lualine_x_diagnostics_error_visual guifg=#B66A5f guibg=#868383]]
            vim.cmd [[highlight! lualine_x_diagnostics_error_insert guifg=#B66A5f guibg=#868383]]
            vim.cmd [[highlight! lualine_x_diagnostics_error_normal guifg=#B66A5F guibg=#868383]]
        end
    })

vim.opt.shortmess:remove({ "F" })

local lspGroup = vim.api.nvim_create_augroup("LspGroup", { clear = true })
vim.api.nvim_create_autocmd({"FileType"},
    {
        group = lspGroup,
        nested = false,
        once = false,
        pattern = { "python", "vim", "haskell", "scala", "sbt", "tex", "json" },
        command = "setlocal omnifunc=v:lua.vim.lsp.omnifunc"
    })

local cmp_group = vim.api.nvim_create_augroup("CmpColors", { clear = true })
vim.api.nvim_create_autocmd({"ColorScheme"}, {
    pattern = "*",
    group = cmp_group
    ,
    callback = function()
        -- ?
        vim.cmd [[highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080]]
        ---- Selection
        vim.cmd [[highlight! CmpItemAbbrMatch      guibg=NONE guifg=#1A1919]]
        vim.cmd [[highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#1A1919]]
        -- Snippet
        vim.cmd [[highlight! CmpItemKindSnippet    guibg=NONE]]
        -- LSP things
        vim.cmd [[highlight! CmpItemKindVariable   guibg=NONE gui=bold]]
        vim.cmd [[highlight! CmpItemKindInterface  guibg=NONE gui=bold]]
        vim.cmd [[highlight! CmpItemKindField      guibg=NONE gui=bold]]
        vim.cmd [[highlight! CmpItemKindEnum       guibg=NONE gui=bold]]
        vim.cmd [[highlight! CmpItemKindFunction   guibg=NONE gui=bold]]
        vim.cmd [[highlight! CmpItemKindMethod     guibg=NONE gui=bold]]
        vim.cmd [[highlight! CmpItemKindKeyword    guibg=NONE gui=bold]]
        vim.cmd [[highlight! CmpItemKindProperty   guibg=NONE gui=bold]]
        vim.cmd [[highlight! CmpItemKindUnit       guibg=NONE gui=bold]]
    end
})
 local capabilities = vim.lsp.protocol.make_client_capabilities()
 capabilities.textDocument.foldingRange = {
     dynamicRegistration = false,
     lineFoldingOnly = true
 }

-- Setup lspconfig.
-- Uses old style lspconfig spec to 'attach' to the modern built-in
-- handler
if pcall(require, "lspconfig") then
    local lspconfig = require('lspconfig')
    local lsp_selection_range = require('lsp-selection-range')
    local capabilities2 = lsp_selection_range.update_capabilities(capabilities)
    local function on_attach_fn(client, bufnr)
        vim.lsp.completion.enable(true, client.id, bufnr, {
            autotrigger = true,
            convert = function(item)
                return { abbr = item.label:gsub("%b()", "") }
            end,
        })
        vim.keymap.set("i", "<C-n>", vim.lsp.completion.get, {desc = "trigger autocompletion"})


        local bmap = function(mode, lhs, rhs, options)
            options = options or {}
            vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
        end

        local function check_codelens_support()
            local clients = vim.lsp.get_active_clients({ bufnr = 0 })
            for _, c in ipairs(clients) do
                if c.server_capabilities.codeLensProvider then
                    return true
                end
            end
            return false
        end
        -- trigger codelens refresh

        vim.api.nvim_create_autocmd(
            { 'TextChanged', 'InsertLeave', 'CursorHold', 'LspAttach', 'BufEnter' },
            {
                buffer = bufnr,
                callback = function()
                    if check_codelens_support() then
                        vim.lsp.codelens.refresh({ bufnr = 0 })
                    end
                end
            })

        -- setup Markdown Oxide daily note commands
        if client.name == "markdown_oxide" then
            vim.api.nvim_create_user_command(
                "Daily",
                function(args)
                    local input = args.args
                    vim.lsp.buf.execute_command({ command = "jump", arguments = { input } })
                end,
                { desc = 'Open daily note', nargs = "*" }
            )
        end
        -- Put here any configuration to execute when attaching a client to a buffer

        -- Create mappings to trigger or expand the selection
        bmap('n', 'vv', [[<cmd>lua require('lsp-selection-range').trigger()<CR>]], { noremap = true })
        bmap('v', 'vv', [[<cmd>lua require('lsp-selection-range').expand()<CR>]], { noremap = true })
    end
    lspconfig.bashls.setup {
        cmd = { "bash-language-server", "start" },
        filetypes = { "sh", "bash", "zsh" },
        capabilities = capabilities2,
        on_attach = on_attach_fn,
    };
    lspconfig.ccls.setup {
        init_options = {
            compilationDatabaseDirectory = "build",
            index = {
                threads = 0,
            },
            clang = {
                excludeArgs = { "-frounding-math" },
            },
        },
        capabilities = capabilities2,
        on_attach = on_attach_fn,
    };
    lspconfig.cssls.setup {
        capabilities = capabilities2,
        on_attach = on_attach_fn,
        cmd = { "vscode-css-languageserver", "--stdio" },
        filetypes = { "css", "scss", "less" },
    };
    lspconfig.fennel_language_server.setup {
        capabilities = capabilities2,
        on_attach = on_attach_fn,
    };
    lspconfig.lua_ls.setup {
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
        capabilities = capabilities2,
        on_attach = on_attach_fn,
    };
    lspconfig.markdown_oxide.setup({
        -- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
        -- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
        capabilities = vim.tbl_deep_extend(
            'force',
            capabilities2,
            {
                workspace = {
                    didChangeWatchedFiles = {
                        dynamicRegistration = true,
                    },
                },
            }
        ),
        on_attach = on_attach_fn,
    })
    lspconfig.marksman.setup {
        capabilities = capabilities2,
        on_attach = on_attach_fn,
    }
    lspconfig.pylsp.setup {
        settings = {
            pyls = {
                plugins = {
                    black = {
                        enabled = true,
                    },
                    isort = {
                        enabled = true,
                    },
                    ruff = {
                        enabled = true,
                        extendSelect = { "I" },
                    },
                    mypy = {
                        enabled = true,
                        live_mode = true,
                        report_progress = true,
                    },
                },
            },
        },
        capabilities = capabilities2,
        on_attach = on_attach_fn,
    };
    lspconfig.jsonls.setup {
        capabilities = capabilities2,
        on_attach = on_attach_fn,
    };
    lspconfig.vimls.setup {
        filetypes = { "vim" },
        cmd = { "vim-language-server", "--stdio" },
        initializationOptions = {
            isNeovim = true,
        },
        capabilities = capabilities2,
        on_attach = on_attach_fn,
    };
    lspconfig.hls.setup {
        cmd = { "haskell-language-server-wrapper", "--lsp" },
        filetypes = { "haskell", "lhaskell" },
        settings = {
            haskell = {
                formattingProvider = "brittany",
            },
        },
        single_file_support = true,
        capabilities = capabilities2,
        on_attach = on_attach_fn,
    };
    lspconfig.texlab.setup {
        settings = {
            bibtex = {
                formatting = {
                    lineLength = 80,
                },
            },
            latex = {
                build = {
                    args = { "-outdir", "build", "-pdf", "-interaction=nonstopmode", "-synctex=1" },
                    executable = "latexmk",
                    onSave = true,
                    outputDirectory = "build",
                },
                lint = {
                    onChange = true,
                },
            },
        },
        capabilities = capabilities2,
        on_attach = on_attach_fn,
    };
end
if pcall(require, 'ufo') then
    require('ufo').setup()
end

-- }}}
