-- {{{ Completion
-- -------------

    -- Better display for messages
    vim.opt.cmdheight = 2
    vim.opt.completeopt = {"menu", "menuone", "noselect"}
    vim.opt.signcolumn = "auto"
    vim.cmd[[sign define DiagnosticSignError text=● texthl=DiagnosticSignError]]
    vim.cmd[[sign define DiagnosticSignWarn  text=● texthl=DiagnosticSignWarn]]
    vim.cmd[[sign define DiagnosticSignInfo  text=● texthl=DiagnosticSignInfo]]
    vim.cmd[[sign define DiagnosticSignHint  text=● texthl=DiagnosticSignHint]]

    local colorSchemeLsp = vim.api.nvim_create_augroup("ColorSchemeLspMod", {clear = true})
    vim.api.nvim_create_autocmd("ColorScheme", {group = colorSchemeLsp, nested = false, once = false, pattern = "*", callback = function()
      vim.cmd[[highlight DiagnosticSignInfo  guifg=skyblue guibg=none ctermfg=blue ctermbg=none]]
       vim.cmd[[highlight DiagnosticSignWarn  guifg=yellow guibg=none ctermfg=yellow ctermbg=none]]
       vim.cmd[[highlight DiagnosticSignError guifg=red guibg=none ctermfg=red ctermbg=none]]
       vim.cmd[[highlight DiagnosticSignHint  guifg=lightgreen guibg=none ctermfg=green ctermbg=none]]
    end})

    vim.opt.shortmess:remove({"F"})

    local lspGroup = vim.api.nvim_create_augroup("LspGroup", {clear = true})
    vim.api.nvim_create_autocmd("FileType", {group = lspGroup, nested = false, once = false, pattern = {"python", "vim", "haskell", "scala", "sbt", "tex", "json"}, command = "setlocal omnifunc=v:lua.vim.lsp.omnifunc"})

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
    local cmp_autopairs = nil
    if pcall(require, "nvim-autopairs.completion.cmp") then
      cmp_autopairs = require('nvim-autopairs.completion.cmp')
    end
    if pcall(require, "cmp") then
      local cmp = package.loaded.cmp
      --cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
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
          ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
    end

    local capabilities = nil
    -- Setup lspconfig.
    if pcall(require, "cmp_nvim_lsp") then
      capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    end

    if pcall(require, "nvim-lsp-installer") then
      require("nvim-lsp-installer").setup {}
    end
    if pcall(require, "lspconfig") then
      local lspconfig = require 'lspconfig'
      lspconfig.bashls.setup{
          cmd = {"bash-language-server", "start"};
          filetypes = {"sh", "bash", "zsh"};
          capabilities = capabilities
      };
      lspconfig.cssls.setup{
          capabilities = capabilities;
          cmd = {"vscode-css-languageserver", "--stdio"};
          filetypes = {"css", "scss", "less"};
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
          capabilities = capabilities
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
          capabilities = capabilities
      };
      lspconfig.jsonls.setup{
          capabilities = capabilities
      };
      lspconfig.vimls.setup{
          filetypes = {"vim"};
          cmd = {"vim-language-server", "--stdio"};
          initializationOptions = {
              isNeovim = true;
          };
          capabilities = capabilities
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
          capabilities = capabilities
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
          capabilities = capabilities
      };
    end
    }
-- }}}
