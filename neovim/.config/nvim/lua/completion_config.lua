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
vim.api.nvim_create_autocmd({ "ColorScheme" },
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
vim.api.nvim_create_autocmd({ "BufRead" },
    {
        group = lspGroup,
        nested = false,
        once = false,
        pattern = '*',
        command = "setlocal omnifunc=v:lua.vim.lsp.omnifunc"
    })
vim.api.nvim_create_autocmd({ "BufRead" },
    {
        group = lspGroup,
        nested = false,
        once = false,
        pattern = '*',
        callback = function()
            vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")
        end
    })
vim.api.nvim_create_autocmd({ "BufRead" },
    {
        group = lspGroup,
        nested = false,
        once = false,
        pattern = '*', -- { "python", "vim", "haskell", "scala", "sbt", "tex", "json" },
        callback = function()
            vim.api.nvim_buf_set_option(0, "tagfunc", "v:lua.vim.lsp.tagfunc")
        end
    })

local cmp_group = vim.api.nvim_create_augroup("CmpColors", { clear = true })
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
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

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, args.buf, {
                autotrigger = true,
                convert = function(item)
                    return { abbr = item.label:gsub("%b()", "") }
                end,
            })
        end
        if not client:supports_method('textDocument/willSaveWaitUntil') and client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                end,
            })
        end
    end
})
local coq = require('coq')
vim.lsp.config("bashls", coq.lsp_ensure_capabilities({
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh", "bash", "zsh" },
}))
vim.lsp.enable('bashls')
vim.lsp.config("ccls", coq.lsp_ensure_capabilities({
    init_options = {
        compilationDatabaseDirectory = "build",
        index = {
            threads = 0,
        },
        clang = {
            excludeArgs = { "-frounding-math" },
        },
    },
}))
vim.lsp.enable('ccls')
vim.lsp.config("cssls", coq.lsp_ensure_capabilities({
    cmd = { 'vscode-css-languageserver', '--stdio' },
    filetypes = { "css", "scss", "less" },
}))
vim.lsp.enable("cssls")
vim.lsp.config("fennel_language_server", coq.lsp_ensure_capabilities({}))
vim.lsp.enable("fennel_language_server")
vim.lsp.config("luals", coq.lsp_ensure_capabilities({
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
}))
vim.lsp.enable("lua_ls")
vim.lsp.config("marksman", coq.lsp_ensure_capabilities({}))
vim.lsp.enable('marksman')
vim.lsp.config("pylsp", coq.lsp_ensure_capabilities({
    settings = {
        pylsp = {
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
}));
vim.lsp.enable("pylsp")
vim.lsp.config("jsonls", coq.lsp_ensure_capabilities({}))
vim.lsp.enable("jsonls")
vim.lsp.config("vimls", coq.lsp_ensure_capabilities({
    filetypes = { "vim" },
    cmd = { "vim-language-server", "--stdio" },
    initializationOptions = {
        isNeovim = true,
    },
}))
vim.lsp.enable("vimls")
vim.lsp.config("hls", coq.lsp_ensure_capabilities({
    cmd = { "haskell-language-server-wrapper", "--lsp" },
    filetypes = { "haskell", "lhaskell" },
    settings = {
        haskell = {
            formattingProvider = "brittany",
        },
    },
    single_file_support = true,
}))
vim.lsp.enable("hls")
vim.lsp.config("texlab", coq.lsp_ensure_capabilities({
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
}))
vim.lsp.enable("texlab")
if pcall(require, 'ufo') then
    require('ufo').setup()
end

-- }}}
