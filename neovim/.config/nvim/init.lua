-- TODO: Move to a lua, then fennel config
-- (example: https://github.com/TunkShif/nvim)
-- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
-- https://github.com/Olical/aniseed
-- https://github.com/lewis6991/impatient.nvim

vim.g.config_path = vim.env.HOME .. '/.config/'

function LoadModuleThen(module, todo)
    require(module)[todo]()
end
pcall(LoadModuleThen, 'impatient', 'enable_profile')

if (vim.g.goneovim or vim.g.neovide) then
    local gui_group = vim.api.nvim_create_augroup('Gui', {clear = true})
    vim.api.nvim_create_autocmd('UIEnter', {
        pattern = '*', group = gui_group
      , callback = function()
           vim.opt.guifont="FiraCode Nerd Font:h10"
           vim.opt.laststatus = 2
           vim.opt.showtabline = 2
           vim.g.neovide_no_idle = true
           vim.g.neovide_cursor_vfx_mode = "wireframe"
           if (vim.g.goneovim) then
               vim.cmd[[GonvimSmoothCursor]]
               vim.cmd[[GonvimSmoothScroll]]
           end
        end
    })
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- {{{ Theme
-- ---------
    vim.opt.showmode = false
    vim.opt.laststatus = 2
    vim.opt.cursorline = true
    vim.opt.colorcolumn = "71"

    vim.o.background = 'dark'
-- }}}

-- {{{ Greek char maps
-- -------------------
    vim.cmd('source ' .. vim.env.HOME .. '/.config/nvim/greek.vim')
-- }}}

-- {{{ Search Options
-- ------------------
    vim.opt.hlsearch = true
    vim.opt.incsearch = true
    vim.opt.wrapscan = false
    vim.opt.ignorecase = true
    vim.opt.smartcase = true
    vim.keymap.set('n', 'n', 'n:lua HlNext(0.4)<CR>', { silent = true })
    vim.keymap.set('n', 'N', 'N:lua HlNext(0.4)<CR>', { silent = true })

    -- Highlight when pressing n or N (Taken from Damian Conway)
    -- http://youtu.be/aHm36-na4-4
    function HlNext(blinktime)
        vim.cmd[[highlight SearchBlink guifg=white guibg=magenta ctermfg=white ctermbg=red]]
        local search_text = vim.api.nvim_eval("@/")
        local col = vim.fn.getpos('.')[3]
        local line_left = string.sub(vim.fn.getline('.'), col)
        local match_len = string.len(vim.fn.matchstr(line_left, search_text))
        local target_pat = '\\c\\%#' .. search_text
        local ring = vim.fn.matchadd("SearchBlink", target_pat, 101)
        vim.cmd("redraw | sleep " .. blinktime * 200 .. "m | call matchdelete(" .. ring .. ")")
    end
-- }}}

-- {{{ Indent Options
-- ------------------
    vim.opt.autoindent = true
    vim.opt.smarttab = true
    vim.opt.expandtab = true
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.textwidth = 70

    vim.opt.linebreak = true
    vim.opt.breakindent = true
    vim.opt.showbreak = "-→"

    vim.g.html_indent_inctags = "head,html,body,p,head,table,tbody,div,script"
    vim.g.html_indent_script1 = "inc"
    vim.g.html_indent_style1 = "inc"
-- }}}

-- {{{ Behaviors
-- -------------
    vim.opt.wrap = true
    vim.opt.lbr = true

    vim.opt.undofile = true
    vim.opt.scrolloff = 5

    vim.opt.history = 1000
    vim.opt.undolevels = 1000

    vim.opt.undodir = vim.env.HOME .. "/.local/share/vim-backup"
    vim.opt.mouse = ""

    vim.opt.backspace = "indent,eol,start"
    vim.opt.cpoptions:append("$")
    vim.opt.ruler = true
    vim.opt.title = true
    vim.opt.autoread = true
    vim.opt.wildmenu = true

    vim.opt.hidden = true
    vim.opt.formatoptions = "coq2"

    vim.opt.pastetoggle = "<F1>"
    vim.keymap.set('', 'gf', ':e <cfile><CR>', { silent = true })

    local qfix_group = vim.api.nvim_create_augroup('QFixToggle', {clear = true})
    vim.api.nvim_create_autocmd('BufWinEnter', {
        pattern = 'quickfix', group = qfix_group
      , desc = "track quickfix window"
      , callback = function()
          vim.g.qfix_win = vim.fn.bufnr("$")
          vim.opt.list = false
          vim.opt.colorcolumn=0
        end
    })
    vim.api.nvim_create_autocmd('BufWinLeave', {
        pattern = '*', group = qfix_group
      , desc = "track quickfix window"
      , command =
          [[if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win
                unlet! g:qfix_win
            endif]]
    })

    -- Create a scratch buffer
    function ScratchBuf()
      local scratchName = "scratch"
      local scratchBuf = vim.fn.bufnr(scratchName)
      if (scratchBuf == -1) then
        scratchBuf = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_buf_set_name(scratchBuf, scratchName)
      end
      vim.api.nvim_win_set_buf(0,scratchBuf)
      vim.opt_local.buftype = "nofile"
      vim.opt_local.bufhidden = "hide"
      vim.opt_local.swapfile = false
    end
    vim.api.nvim_create_user_command("Scratch", ScratchBuf, {})
    vim.keymap.set('', '<C-s>', ":Scratch<CR>")
-- }}}

-- {{{ Visual
-- ----------
    vim.opt.showmatch = true
    vim.opt.list = true
    vim.opt.conceallevel = 0

    -- Requires treesitter/playground plugin
    vim.keymap.set('n', '<F10>', ':TSHighlightCapturesUnderCursor<CR>', { silent = true })
    local CsFoldGroup = vim.api.nvim_create_augroup("ColorSchemeFoldMod", {clear = true})
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*", group = CsFoldGroup
      , command =
        [[highlight SpecialKey ctermfg=red cterm=none
          highlight Folded guifg=magenta gui=bold ctermbg=none ctermfg=magenta cterm=bold
          highlight VertSplit guibg=none ctermbg=none guifg=#afafaf ctermfg=237]]
    })
    vim.opt.termguicolors = true

    local CsCommentGroup = vim.api.nvim_create_augroup("ColorSchemeComment", {clear = true})
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*", group = CsCommentGroup
      , command =
        [[highlight Comment guifg=#df5f5f ctermfg=167 guibg=none ctermbg=none gui=none cterm=none]]
    })

    vim.opt.listchars = ""
    vim.opt.listchars:append("tab:▕░")
    vim.opt.listchars:append("trail:▒")
    vim.opt.listchars:append("extends:>")
    vim.opt.listchars:append("precedes:<")
-- }}}

-- {{{ Nvim Terminal mode
-- ----------------------
    vim.env.NVIM_LISTEN_ADDRESS = vim.v.servername
    vim.keymap.set('t', '<c-w>', '<c-\\><c-n>', { silent = true })

    local term_group = vim.api.nvim_create_augroup('Terminal', {clear = true})
    vim.api.nvim_create_autocmd('TermOpen', {
        pattern = '*', group = term_group
      , callback = function()
          vim.opt.filetype = "terminal"
          -- Black
          vim.b.terminal_color_0 = '#272822'
          vim.b.terminal_color_8 = '#75715e'
          -- Red
          vim.b.terminal_color_1  = '#f92672'
          vim.b.terminal_color_9  = '#f92672'
          -- Green
          vim.b.terminal_color_2  = '#a6e22e'
          vim.b.terminal_color_10 = '#a6e22e'
          -- Yellow
          vim.b.terminal_color_3  = '#f4bf75'
          vim.b.terminal_color_11 = '#f4bf75'
          -- Blue
          vim.b.terminal_color_4  = '#66d9ef'
          vim.b.terminal_color_12 = '#66d9ef'
          -- Magenta
          vim.b.terminal_color_5  = '#ae81ff'
          vim.b.terminal_color_13 = '#ae81ff'
          -- Cyan
          vim.b.terminal_color_6  = '#a1efe4'
          vim.b.terminal_color_14 = '#a1efe4'
          -- White
          vim.b.terminal_color_7  = '#989892'
          vim.b.terminal_color_15 = '#f9f8f5'
        end
    })
-- }}}

-- {{{ Folds
-- ---------
    vim.opt.foldcolumn = "0"
    -- Always show folds open
    vim.opt.foldlevelstart = 99

    vim.keymap.set('', 'z[', ':set foldlevel=99<CR>', { silent = true })
    vim.keymap.set('', 'z]', ':set foldlevel=0<CR>', { silent = true })

    vim.opt.viewoptions:remove('options')

    local fold_group = vim.api.nvim_create_augroup('Folds', {clear = true})
    vim.api.nvim_create_autocmd('FileType', {
        pattern = {'vim', 'zsh'}, group = fold_group
        , callback = function()
            vim.opt_local.foldmethod="marker"
            vim.opt_local.foldtext="v:lua.SimpleFoldText()"
          end
    })
    vim.opt.foldtext = 'v.lua.CFoldText()'

    function PadToRight(lstring, rstring)
        local width = vim.fn.winwidth('.')
        local offset = string.rep(' ', width - string.len(lstring .. rstring))
        return lstring .. offset .. rstring
    end

    function SimpleFoldText()
        local ell = ' ⋯ '
        local vstart = vim.fn.getline(vim.v.foldstart)
        local vend = vim.fn.trim(vim.fn.getline(vim.v.foldend))
        local startpattern = "^%s*[\"#-]%-?%s*{{{" -- sh, vim, or lua style comments
        local endpattern = "^%s*[\"#-]%-?%s*}}}"
        if (string.match(vstart, startpattern)) then
            vstart = string.gsub(vstart, startpattern, "")
        end
        if (string.match(vend, endpattern)) then
            vend = string.gsub(vend, endpattern, "")
        end
        local linestring = " === " .. table.maxn(vim.fn.getline(vim.v.foldstart, vim.v.foldend)) .. " lines === "
        return PadToRight(vstart .. " " .. ell .. " " .. vend, linestring)
    end

    function CFoldText()
        local ell = ' ⋯ '
        local lines = vim.fn.getline(vim.v.foldstart, vim.v.foldend)
        local size = table.maxn(lines)
        local linestring = " === " .. size .. " lines === "
        local vstart = vim.fn.getline(vim.v.foldstart)
        if (string.match(vstart, "{$") or string.match(vstart, "=$")) then
            local result = vstart .. ell .. vim.fn.trim(vim.fn.getline(vim.v.foldend)) .. ' '
            return PadToRight(result, linestring)
        end
        local had_comma = false
        new_lines = {}
        for ix,line in pairs(lines) do
            local curline = line
            if (ix ~= 1) then
                curline = vim.fn.trim(curline)
                curline = string.gsub(curline, "%s+", " ")
            end
            if (had_comma) then
                curline = ' ' .. curline
            end
            if (string.match(curline, ",$")) then
                had_comma = true
            end
            had_comma = false
            new_lines[ix] = curline
            if (string.match(line, "%)%s*:.*=%s*")) then
                new_lines[ix]= ")"
                break
            end
        end
        local result = table.concat(new_lines)
        return pad_to_right(result, linestring)
    end
-- }}}

-- {{{ Keymaps
-- ---------------
    -- Emacs-like movements for the cmdline
    vim.keymap.set('c', '<C-a>', '<Home>')
    vim.keymap.set('c', '<C-f>', '<Right>')
    vim.keymap.set('c', '<C-b>', '<Left>')
    vim.keymap.set('c', '<Esc>b', '<S-Left>')
    vim.keymap.set('c', '<Esc>f', '<S-Right>')

    vim.keymap.set('i', 'jk', '<ESC>')

    vim.keymap.set('', 'k', 'gk', {silent = true})
    vim.keymap.set('', 'j', 'gj', {silent = true})
    vim.keymap.set('', '0', 'g0', {silent = true})
    vim.keymap.set('', '$', 'g$', {silent = true})
    vim.keymap.set('', 'gk', 'k', {silent = true})
    vim.keymap.set('', 'gj', 'j', {silent = true})
    vim.keymap.set('', 'g0', '0', {silent = true})
    vim.keymap.set('', 'g$', '$', {silent = true})

    vim.keymap.set('', '<C-n>', ':bnext<CR>', {silent = true})

    vim.keymap.set('i', '<C-n>', 'pumvisible() ? "\\<C-n>" : "\\<C-x>\\<C-o>"', {silent = true, expr = true})
    vim.keymap.set('i', '<C-j>', 'pumvisible() ? "\\<C-n>" : "\\<C-x>\\<C-o>"', {silent = true, expr = true})

    vim.keymap.set('i', "<C-k>", "<C-p>", {silent = true})
    vim.keymap.set('i', "<S-TAB>", 'pumvisible() ? "\\<C-p>" : "\\<C-h>"', {silent = true, expr = true})

    vim.keymap.set('', "<C-b>", ":bprev<CR>", {silent = true})
    vim.keymap.set('', "<leader>n", ":tabnext<CR>", {silent = true})
    vim.keymap.set('', "<leader>b", ":tabprev<CR>", {silent = true})
    vim.keymap.set('', "<C-w>c", ":tabnew<CR>", {silent = true})
    vim.keymap.set('', "<C-w>n", ":tabnext<CR>", {silent = true})
    vim.keymap.set('', "<C-w>b", ":tabprev<CR>", {silent = true})
    vim.keymap.set('', ';', ':', {silent = true})

    vim.keymap.set('c', "w;", 'w<CR>')

    vim.keymap.set('', '<leader>c', ':set spell!<CR>', {silent = true})

    vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", {silent = true})
    vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", {silent = true})
-- }}}

-- {{{ Auto Commands
-- ---------------
    local util_group = vim.api.nvim_create_augroup('Utilities', {clear = true})
    vim.api.nvim_create_autocmd('BufReadPost', {
        pattern = '*', group = util_group
        , command =
            [[if line("'\"") > 1 && line("'\"") <= line("$") |
                exe "normal! g`\"" |
              endif]]
    })

    local tex_group = vim.api.nvim_create_augroup('LaTeX', {clear = true})
    vim.api.nvim_create_autocmd('FileType', {pattern = 'tex', group = tex_group,
      command = 'set fenc=ascii'
    })

    local help_group = vim.api.nvim_create_augroup('HelpFiles', {clear = true})
    vim.api.nvim_create_autocmd('FileType', {pattern = 'help', group = help_group,
      command = "source " .. vim.g.config_path .. 'nvim/ftplugin/help.vim'
    })

    local scala_group = vim.api.nvim_create_augroup('Scala', {clear = true})
    vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {pattern = '*.sc', group = scala_group,
      command = "set filetype=scala"
    })

-- }}}

-- {{{ netrw
-- ---------
    -- Hit enter in the file browser to open the selected
    -- file with :vsplit to the right of the browser.
    vim.g.netrw_browse_split = 4
    vim.g.netrw_altv = 1

    vim.g.netrw_list_hide = '^\\.'
    vim.g.netrw_hide = 1
-- }}}

-- {{{ Plugins
-- --------------
    function TmuxNavConfig()
        vim.keymap.set('', '<C-h>', ":TmuxNavigateLeft<CR>", {silent = true})
        vim.keymap.set('', '<C-l>', ":TmuxNavigateRight<CR>", {silent = true})
        vim.keymap.set('', '<C-k>', ":TmuxNavigateUp<CR>", {silent = true})
        vim.keymap.set('', '<C-j>', ":TmuxNavigateDown<CR>", {silent = true})
    end

    function ScalaSetup()
      local ScalaGroup = vim.api.nvim_create_augroup('ScalaGroup', {clear = true})
      vim.api.nvim_create_autocmd('FileType', {pattern = {'scala', 'sbt'}, group = ScalaGroup,
        desc = "Attach an instance of metals (lsp)",
        callback = function() require("metals").initialize_or_attach({}) end
      })
    end

    function JavaSetup()
      local JavaGroup = vim.api.nvim_create_augroup('JavaGroup', {clear = true})
      vim.api.nvim_create_autocmd('FileType', {pattern = 'java', group = JavaGroup,
        desc = "Attach an instance of jdtls (lsp)",
        callback = function() require("java_jdtls") end
      })
    end

    vim.keymap.set('c', "s;", 'Sayonara!<CR>')
    function SayoConfig()
        vim.api.nvim_create_user_command('S', 'Sayonara!', {})
        vim.api.nvim_create_user_command('Sa', 'Sayonara', {})
        vim.g.sayonara_confirm_quit = true
    end

    require('plugins')

-- }}}
vim.cmd[[colorscheme janah]]
