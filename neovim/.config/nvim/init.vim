scriptencoding utf-8

let config_path = $HOME . '/.config/'

let g:mapleader = ' '
let g:maplocalleader = ' '

" {{{ Theme
" ---------------
    set noshowmode
    set laststatus=2 "always show the status line
    " enable 256 color mode
    filetype plugin on
    syntax enable

    set background=dark
    highlight Search     cterm=none gui=none guibg=grey ctermbg=247
    highlight MatchParen cterm=none gui=none guibg=grey ctermbg=247

    set cursorline  " NOTE: CAN LEAD TO SIGNIFICANT SLOWDOWNS

    " line at 80 chars
    if exists('+colorcolumn')
      set colorcolumn=71
    else
      match DiffAdd '\%>71v.*' "Shittier way, but it works for vim < 7.3
    endif
    highlight Folded ctermfg=darkmagenta ctermbg=none cterm=bold
    if has('nvim')
        highlight Folded guifg='#ba8baf' guibg=none gui=bold
    endif
    highlight SpellCap guibg=8 ctermbg=8

    highlight Conceal guibg=none ctermbg=none
" }}}

" {{{ Greek char maps
" ---------------
    exec 'source ' . config_path . 'nvim/greek.vim'
" }}}

" {{{ Search Options
" ---------------
    set hlsearch
    set incsearch
    set nowrapscan
    set ignorecase
    set smartcase

    " Highlight when pressing n or N (Taken from Damian Conway)
    " http://youtu.be/aHm36-na4-4

    " This rewires n and N to do the highlighing...
    nnoremap <silent> n   n:call HLNext(0.4)<cr>
    nnoremap <silent> N   N:call HLNext(0.4)<cr>
    " Highlight the match in red
    function! HLNext (blinktime)
        highlight WhiteOnRed guifg=white guibg=red ctermfg=white ctermbg=red
        let [l:bufnum, l:lnum, l:col, l:off] = getpos('.')
        let l:matchlen = strlen(matchstr(strpart(getline('.'),l:col-1),@/))
        let l:target_pat = '\c\%#'.@/
        let l:ring = matchadd('WhiteOnRed', l:target_pat, 101)
        redraw
        exec 'sleep ' . float2nr(a:blinktime * 200) . 'm'
        call matchdelete(l:ring)
        redraw
    endfunction
" }}}

" {{{ Indent Options
" ---------------
    set autoindent
    set smarttab
    set expandtab
    set tabstop=4
    set shiftwidth=4
    set textwidth=70

    set linebreak
    set breakindent

    " Try to get the indent to be more like emacs
    " Taken from some dude, with his comments paraphrased by me
    set cinkeys=0{,0},0),0#,!<Tab>,;,:,o,O,e " From vim's help
    set indentkeys=!<Tab>,o,O                " ditto
    filetype indent on
    " Kernel-style
    set cinoptions=:0,(0,u0,W1s

    let g:html_indent_inctags='head,html,body,p,head,table,tbody,div,script'
    let g:html_indent_script1='inc'
    let g:html_indent_style1='inc'
" }}}

" {{{ Behaviors
" ---------------

    " Wrap lines, and move cursor along display lines
    set wrap lbr " wrap at line breaks

    set undofile
    set scrolloff=5

    set history=1000
    set undolevels=1000
    set undodir=$HOME/.local/share/vim-backup
    set mouse=

    set backspace=indent,eol,start "taken from archlinux.vim
    set cpoptions+=$               " vi-like text change/delete
    set ruler          " Display <line,char %>
    set title
    set autoread
    set wildmenu

    " Don't exit when opening a new buffer
    set hidden

    set formatoptions=coq2

    set pastetoggle=<F1>

    "" Always open a file on gf (even if it doesn't exist)
    map gf :e <cfile><CR>

    " used to track the quickfix window
    augroup QFixToggle
        autocmd!
        autocmd BufWinEnter quickfix let g:qfix_win = bufnr("$")
        autocmd BufWinEnter quickfix set nolist
        autocmd BufWinEnter quickfix set colorcolumn=0
        autocmd BufWinLeave * if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win | unlet! g:qfix_win | endif
    augroup END
" }}}

" {{{ Visual
" ---------------

    set showmatch "Highlight matching paren
    set list

    set conceallevel=0

    map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
    \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
    highlight SpecialKey ctermfg=red cterm=none
    highlight Folded guibg=none guifg=magenta gui=bold ctermbg=none ctermfg=magenta cterm=bold

    "highlight SpecialKey ctermbg=none ctermfg=none
    set listchars=""
    set listchars=tab:▕░
    set listchars+=trail:▒
    " For when wrap is off
    set listchars+=extends:>
    set listchars+=precedes:<
" }}}

" {{{ Nvim Terminal mode
" ---------------
    if has('nvim')
      let $VISUAL = 'nvr -cc split --remote-wait'
      tnoremap <c-w> <c-\><c-n>
      augroup Terminal
          autocmd!
          autocmd TermOpen * setlocal nocursorline

          " Black
          autocmd TermOpen * let b:terminal_color_0  = '#272822'
          autocmd TermOpen * let b:terminal_color_8  = '#75715e'

          " Red
          autocmd TermOpen * let b:terminal_color_1  = '#f92672'
          autocmd TermOpen * let b:terminal_color_9  = '#f92672'

          " Green
          autocmd TermOpen * let b:terminal_color_2  = '#a6e22e'
          autocmd TermOpen * let b:terminal_color_10 = '#a6e22e'

          " Yellow
          autocmd TermOpen * let b:terminal_color_3  = '#f4bf75'
          autocmd TermOpen * let b:terminal_color_11 = '#f4bf75'

          " Blue
          autocmd TermOpen * let b:terminal_color_4  = '#66d9ef'
          autocmd TermOpen * let b:terminal_color_12 = '#66d9ef'

          " Magenta
          autocmd TermOpen * let b:terminal_color_5  = '#ae81ff'
          autocmd TermOpen * let b:terminal_color_13 = '#ae81ff'

          " Cyan
          autocmd TermOpen * let b:terminal_color_6  = '#a1efe4'
          autocmd TermOpen * let b:terminal_color_14 = '#a1efe4'

          " White
          autocmd TermOpen * let b:terminal_color_7  = '#989892'
          autocmd TermOpen * let b:terminal_color_15 = '#f9f8f5'
      augroup END
  endif
" }}}

" {{{ Folds
" ---------------
    set foldcolumn=0
    " Always show folds open
    set foldlevelstart=99
    " open folds
    noremap <silent> z[ :set foldlevel=99<CR>
    " close folds
    noremap <silent> z] :set foldlevel=0<CR>

    set viewoptions-=options
    augroup Folds
        autocmd!
        autocmd FileType vim setlocal foldmethod=marker | setlocal foldtext=SimpleFoldText()
        autocmd FileType zsh setlocal foldmethod=marker | setlocal foldtext=SimpleFoldText()
    augroup END
    set foldtext=CFoldText()

    function! PadToRight(lstring, rstring)
        let l:width = (winwidth('.') - 0)
        let l:offset =  repeat(" ", l:width - strlen(a:lstring . a:rstring))
        return a:lstring . l:offset . a:rstring
    endfunction

    function! SimpleFoldText()
        let l:ell = ' ⋯ '
        let l:start = getline(v:foldstart)
        let l:end = trim(getline(v:foldend))
        let l:quotepattern = "^\\s*\\(\"\\|#\\)\\s*\\({{{\\|}}}\\)\\?"
        if l:start =~ l:quotepattern
            let l:start = substitute(l:start, l:quotepattern, " ", "")
        endif
        if l:end =~ l:quotepattern
            let l:end = substitute(l:end, l:quotepattern, " ", "")
        endif
        let l:linestring = " === " . len(getline(v:foldstart, v:foldend)) . " lines === "
        return PadToRight(l:start . " " . l:ell . " " . l:end, l:linestring)
    endfunction

    " Actually designed with scala in mind...
    function! CFoldText()
        let l:ell = " ⋯ "
        let l:lines = getline(v:foldstart, v:foldend)
        let l:size = len(l:lines)
        let l:linestring = " === " . l:size . " lines === "
        if (getline(v:foldstart) =~ "{$") || (getline(v:foldstart) =~ "=$")
            let l:result = getline(v:foldstart) . l:ell . trim(getline(v:foldend)) . ' '
            return PadToRight(l:result, l:linestring)
        endif
        let l:ix = 0
        let l:hadComma = 0
        for l:line in l:lines
            if l:ix != 0
                let l:lines[l:ix] = trim(l:lines[l:ix])
            endif
            if l:hadComma
                let l:lines[l:ix] = " " . l:lines[l:ix]
            endif
            if l:line =~ "):.*= {"
                break
            endif
            let l:hadComma = 0
            if l:line =~ ",$"
                let l:hadComma = 1
            endif
            let l:ix = l:ix + 1
        endfor
        let l:result = join(l:lines[:l:ix], "") . l:ell . trim(getline(v:foldend)) . ' '
        return PadToRight(l:result, l:linestring)
    endfunction

" }}}

" {{{ Keymaps
" ---------------
    "noremap <silent> <C-a> :retab<CR>:%s/ *$//<CR>:noh<cr><C-o>

    " Emacs-like movements for the cmdline
    cnoremap <C-A> <Home>
    cnoremap <C-F> <Right>
    cnoremap <C-B> <Left>
    cnoremap <Esc>b <S-Left>
    cnoremap <Esc>f <S-Right>

    " Faster and easier esc
    imap jk <Esc>

    noremap <silent> k gk
    noremap <silent> j gj
    noremap <silent> 0 g0
    noremap <silent> $ g$

    noremap <silent> g$ $
    noremap <silent> g0 0
    noremap <silent> gj j
    noremap <silent> gk k

    noremap <C-n> :bnext<CR>
    inoremap <silent><expr> <C-n>
          \ pumvisible() ? "\<C-n>" : "\<C-x>\<C-o>"
    inoremap <silent><expr> <C-j>
          \ pumvisible() ? "\<C-n>" : "\<C-x>\<C-o>"
    inoremap <silent> <C-k> <C-p>
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
    noremap <C-b> :bprev<CR>
    noremap <leader>n :tabnext<CR>
    noremap <leader>b :tabprev<CR>

    " Use ; for : in normal and visual mode, less keystrokes
    nnoremap ; :
    vnoremap ; :

    " Faster save keystrokes
    "save with ;w'
    cnoremap w' w<CR>
    "save with ;w;
    cnoremap w; w<CR>

    " Toggle spellchecker #(spelling, dictionary)
    nnoremap <silent> <leader>c :set spell!<CR>

" }}}

" {{{ Auto Commands
" ---------------

    augroup Utilities
        autocmd!
        " Always jump to the last cursor position when editing a file
        autocmd BufReadPost *
                    \ if line("'\"") > 1 && line("'\"") <= line("$") |
                    \   exe "normal! g`\"" |
                    \ endif
    augroup END

    augroup LaTeX
        autocmd!
        " Set ascii encoding in latex files
        autocmd FileType tex set fenc=ascii
    augroup END

    augroup VimFiles
        autocmd!
        " Better help navigation
        autocmd FileType help exec 'source ' . config_path . 'nvim/ftplugin/help.vim'
    augroup END

    augroup Scala
        autocmd!
        autocmd BufNewFile,BufRead *.sc set filetype=scala
    augroup END
" }}}

" {{{ netrw
" ---------------
    " Hit enter in the file browser to open the selected
    " file with :vsplit to the right of the browser.
    let g:netrw_browse_split = 4
    let g:netrw_altv = 1

    let g:netrw_list_hide = '^\.'
    let g:netrw_hide = 1
" }}}

" {{{ Plugins
" --------------

    " {{{ Pathogen Infection
    " ----------------------
    call pathogen#infect()
    call plug#begin(config_path . 'nvim/plugged')

    " Vim Wiki
    Plug 'vimwiki/vimwiki'

    " When you type one bracket, you get two
    Plug 'Raimondi/delimitMate'

    " HTML editing
    Plug 'mattn/emmet-vim'

    " Undo tree
    Plug 'mbbill/undotree'

    " Haskell
    Plug 'neovimhaskell/haskell-vim', {'for' : 'haskell'}

    " Repeat vim plugin commands with .
    Plug 'tpope/vim-repeat'

    " Faster Movement
    Plug 'easymotion/vim-easymotion'

    " Show mappings
    Plug 'urbainvaes/vim-remembrall'

    " Better treatment of things like quotes, brackets
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-speeddating'

    Plug 'neovim/nvim-lsp'
    Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
    Plug 'Shougo/deoplete-lsp'

    Plug 'Shougo/echodoc.vim'

    Plug 'sbdchd/neoformat'

    Plug 'itchyny/lightline.vim'
    Plug 'mengelbrecht/lightline-bufferline'
    Plug 'ryanoasis/vim-devicons'

    " Tmux integration
    Plug 'christoomey/vim-tmux-navigator'

    " Markdown
    Plug 'mattly/vim-markdown-enhancements'

    " Better splash screen
    Plug 'mhinz/vim-startify'

    " Latex
    Plug 'lervag/vimtex'
    Plug 'rbonvall/vim-textobj-latex', { 'for' : 'tex' }
                \| Plug 'kana/vim-textobj-user'

    " Git-friendliness
    Plug 'airblade/vim-gitgutter'

    Plug 'junegunn/vim-easy-align'

    Plug 'mhinz/vim-janah'

    Plug 'ElmCast/elm-vim'

    Plug 'rbgrouleff/bclose.vim'

    Plug 'sjbach/Lusty'

    Plug 'junegunn/limelight.vim'
    Plug 'junegunn/goyo.vim'

    Plug 'rliang/termedit.nvim'

    Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

    call plug#end()
    " }}}
    colorscheme janah
    highlight Comment guifg=#df5f5f ctermfg=167 guibg=none ctermbg=none gui=none cterm=none

    " {{{ LustyJuggler Fix (Archlinux)
    " --------------------------------
        let g:ruby_host_prog = '/usr/bin/neovim-ruby-host'
    " }}}


    " {{{ VimWiki
    " -----------
        augroup Wiki
            autocmd!
            autocmd FileType vimwiki nmap <silent><buffer> <leader>wt <Plug>VimwikiToggleListItem
            autocmd FileType vimwiki nmap <silent><buffer> <CR> <Plug>VimwikiTabnewLink
        augroup END
    " }}}
    " {{{ Magit
    " ----------
        augroup Magit
            autocmd!
            autocmd FileType magit set colorcolumn=0
        augroup END


        let g:gitgutter_sign_added='┃'
        let g:gitgutter_sign_modified='┃'
        let g:gitgutter_sign_removed='┃'
        let g:gitgutter_sign_removed_first_line='╓'
        let g:gitgutter_sign_modified_removed='┣'
    " }}}
    " {{{ Lightline
        let g:lightline = {
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'fugitive', 'readonly', 'modified' ],
        \             [ 'buffers' ] ],
        \   'right': [ [ 'lineinfo' ],
        \              [ 'percent' ],
        \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
        \ },
        \ 'colorscheme': 'jellybeans',
        \ 'component_function': {
        \   'fileformat': 'LightlineFileformat',
        \   'fileencoding': 'LightlineFileencoding',
        \   'filetype': 'LightlineFiletype',
        \   'fugitive': 'LightlineFugitive',
        \   'readonly': 'LightlineReadonly',
        \ },
        \ 'separator': { 'left': '', 'right': '' },
        \ 'subseparator': { 'left': '', 'right': '' }
        \}
        function! LightlineFileformat()
            if &fileformat != 'unix'
                return winwidth(0) > 70 ? &fileformat : ''
            endif
            return ''
        endfunction
        function! LightlineFileencoding()
            if (&fenc !=# 'utf-8' && &fenc !=# '')
                return winwidth(0) > 70 ? &fenc : ''
            endif
            return ''
        endfunction
        function! LightlineFiletype()
            return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
        endfunction
        function! LightlineReadonly()
            return &readonly ? '' : ''
        endfunction
        function! LightlineFugitive()
            if exists('*fugitive#head')
                let branch = fugitive#head()
                return branch !=# '' ? ''.branch : ''
            endif
            return ''
        endfunction

        " bufferline
        let g:lightline#bufferline#filename_modifier = ':t'
        let g:lightline#bufferline#shorten_path = 0
        let g:lightline#bufferline#enable_devicons = 1
        let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
        let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
        let g:lightline.component_type   = {'buffers': 'tabsel'}
        autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()
    " }}}
    " {{{ Gundo
    " --------------
        nnoremap <leader>u :UndotreeToggle<CR>
    " }}}
    " {{{ Autoformat
    " --------------
        let g:neoformat_sql_mysqlformat = {
                \ 'exe': 'sqlformat',
                \ 'args': ['-k', 'upper', '--reindent', '--comma_first', 'True', '-'],
                \ 'stdin': 1,
                \ }

        let g:neoformat_tex_mylatexindent = {
                \ 'exe': 'latexindent',
                \ 'args': ['-m', '-sl', '-g /dev/stderr', '2>/dev/null'],
                \ 'stdin': 1,
                \}

        let g:neoformat_enabled_tex = ['mylatexindent']
        let g:neoformat_enabled_sql = ['mysqlformat']
        let g:neoformat_enabled_scalariform = ['scalariform']

        " Enable tab to spaces conversion
        let g:neoformat_basic_format_retab = 1

        " Enable trimmming of trailing whitespace
        let g:neoformat_basic_format_trim = 1

        let g:neoformat_run_all_formatters = 1

        augroup fmt
            autocmd!
            au BufWritePre * try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
        augroup END
    " }}}
    " {{{ Completion
    " -------------

        " Better display for messages
        set cmdheight=2

        " don't give |ins-completion-menu| messages.
        "set shortmess+=c
        set completeopt-=preview
        let g:deoplete#enable_at_startup = 1

        " always show signcolumns
        set signcolumn=yes

        let g:LspDiagnosticsErrorSign = "●"
        let g:LspDiagnosticsWarningSign = "●"
        let g:LspDiagnosticsInformationSign = "●"
        let g:LspDiagnosticsHintSign = "●"
        highlight LspDiagnosticInformation guifg=blue   guibg=none ctermfg=blue   ctermbg=none
        highlight LspDiagnosticsWarning    guifg=yellow guibg=none ctermfg=yellow ctermbg=none
        highlight LspDiagnosticsError      guifg=red    guibg=none ctermfg=red    ctermbg=none
        highlight LspDiagnosticHint        guifg=green  guibg=none ctermfg=green  ctermbg=none

        "set completeopt=noinsert,menuone,noselect
        nnoremap <silent> gs  <cmd>lua vim.lsp.buf.declaration()<CR>
        nnoremap <silent> gd  <cmd>lua vim.lsp.buf.definition()<CR>
        nnoremap <silent> K   <cmd>lua vim.lsp.buf.hover()<CR>
        nnoremap <silent> gD  <cmd>lua vim.lsp.buf.implementation()<CR>
        nnoremap <silent> gk  <cmd>lua vim.lsp.buf.signature_help()<CR>
        nnoremap <silent> 1gD <cmd>lua vim.lsp.buf.type_defintion()<CR>
        nnoremap <silent> gk  <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>
        nnoremap <silent> gn  <cmd>lua vim.lsp.buf.formatting()<CR>

        augroup LspGroup
            autocmd!
            autocmd Filetype python  setlocal omnifunc=v:lua.vim.lsp.omnifunc
            autocmd Filetype vim     setlocal omnifunc=v:lua.vim.lsp.omnifunc
            autocmd Filetype haskell setlocal omnifunc=v:lua.vim.lsp.omnifunc
            autocmd Filetype scala   setlocal omnifunc=v:lua.vim.lsp.omnifunc
            autocmd Filetype tex     setlocal omnifunc=v:lua.vim.lsp.omnifunc
            autocmd Filetype json    setlocal omnifunc=v:lua.vim.lsp.omnifunc
        augroup END
        lua << EOF
        local lspconfig = require 'lspconfig'
        lspconfig.pyls.setup{
            settings = {
                pyls = {
                    plugins = {
                        black = {
                            enabled = true;
                        };
                    };
                };
            };
        }
        lspconfig.jsonls.setup{
            cmd = {"json-languageserver", "--stdio"};
        };
        lspconfig.vimls.setup{}
        lspconfig.metals.setup{
            cmd = {"metals-client"};
        }
        lspconfig.hie.setup{
            init_options = {
                languageServerHaskell = {
                    logFile = "/tmp/hie-logs.txt";
                    liquidOn = true;
                    formattingProvider = "ormolu";
                    formatOnImportOn = true;
                };
            };
        }
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
        }
EOF
    " }}}
    " {{{ Delimitmate
    " -------------
        augroup DelimitLisp
            autocmd!
            autocmd FileType scheme let b:loaded_delimitMate = 1
            autocmd FileType lisp let b:loaded_delimitMate = 1
            autocmd FileType clojure let b:loaded_delimitMate = 1
        augroup END
        let g:delimitMate_balance_matchpairs = 1
        let g:delimitMate_excluded_regions = 'Comment,String,Constant'
        let g:delimitMate_expand_space = 1
        let g:delimitMate_expand_cr = 1
    " }}}
    " {{{ Haskell things
    " -----------------
        let g:no_haskell_conceal = 1
        augroup Haskell
            autocmd!

            autocmd BufNewFile,BufRead *.fr setfiletype frege
            autocmd FileType haskell set cinkeys=0{,0},0),0#,!<Tab>,;,:,o,O,e
            autocmd FileType haskell set indentkeys=!<Tab>,o,O
        augroup END

        " neovimhaskell/haskell-vim
        let g:haskell_indent_if  = 0
        let g:haskell_indent_case = 2
        let g:haskell_indent_let = 4
        let g:haskell_indent_where = 6
        let g:haskell_indent_do = 3
        let g:haskell_indent_in = 0
        let g:haskell_indent_guard = 2

    " }}}
    " {{{ Emmet
    " -------------
        let g:user_emmet_mode='inv'
        let g:user_emmet_install_global = 0
        augroup Emmet
            autocmd!
            autocmd FileType html inoremap <buffer> <tab> <esc>:call emmet#expandAbbr(0, "")<cr>a
        augroup END

        let g:user_emmet_settings = {
        \ 'html' : {
        \     'indentation' : '    '
        \ },
        \}
    " }}}
    " {{{ Startify
    " -------------
        function! StartifyEntryFormat()
            return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
        endfunction

        function! NrToHint(number, indices)
            let l:number = a:number
            let l:hint = ''
            if l:number < len(a:indices)
                return a:indices[l:number]
            endif
            while 1
                let l:hint = a:indices[l:number % len(a:indices)] . l:hint
                let l:number = l:number / len(a:indices) - 1
                if l:number < 0
                    return l:hint
                endif
            endwhile
        endfunction

        let g:startify_indices = ['a', 'd', 'f', 'g', 'h', 'l']
        let g:startify_custom_indices = map(range(0,100), 'NrToHint(v:val, g:startify_indices)')

        let g:startify_files_number = 4
        let g:startify_bookmarks = [config_path . 'nvim/init.vim', $HOME . '/.zshrc']
        let g:startify_list_order = [
                    \ ['MRU'],
                    \ 'files',
                    \ ['Bookmarks'],
                    \ 'bookmarks',
                    \ ['Sessions'],
                    \ 'sessions',
                    \ ['Cmds'],
                    \ 'commands',
                    \]
        let g:startify_skiplist = [
                    \ 'COMMIT_EDITMSG',
                    \ '.git/index',
                    \ 'plugged/.*/doc',
                    \ 'nvim/runtime/doc*',
                    \ config_path . 'nvim/init.vim',
                    \ $HOME . '/.zshrc',
                    \ ]

        function! s:filter_header(lines) abort
            let l:cols = 80
            let l:longest_line   = max(map(copy(a:lines), 'len(v:val)'))
            let l:centered_lines = map(copy(a:lines),
                \ 'repeat("' . ' ", (l:cols / 2) - (l:longest_line / 2)) . v:val')
            return l:centered_lines
        endfunction
        let g:startify_custom_header =
                    \ s:filter_header(
                    \   map(
                    \     split(
                    \       system('~/bin/random_description.sh | cowthink -W 40 -f tux -n'),
                    \     '\n'),
                    \   '" ' . '". v:val') + ['',''])
    " }}}
    " {{{ Vimtex
    " -------------

        let g:tex_flavor = 'latex'
        let g:vimtex_compiler_latexmk = {
                    \ 'build_dir' : './build',
                    \}
        let g:vimtex_view_method = 'zathura'
        let g:vimtex_complete_enabled = 0
        augroup Latex
            autocmd!
            autocmd BufEnter *tex setfiletype tex
        augroup END

    " }}}
    " {{{ EasyAlign
    " --------------
        " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
        vmap <Enter> <Plug>(EasyAlign)

        " Start interactive EasyAlign for a motion/text object (e.g. gaip)
        nmap ga <Plug>(EasyAlign)
    " }}}
    " {{{ Git Gutter
    " --------------
        set updatetime=300
    " }}}
    " {{{ Goyo
    " --------
        let g:limelight_priority = -1
        let g:limelight_conceal_ctermfg = 240
        function! s:goyo_enter()
          highlight ALEInfoSign    guifg=blue   guibg=none ctermfg=blue   ctermbg=none
          highlight ALEWarningSign guifg=yellow guibg=none ctermfg=yellow ctermbg=none
          highlight ALEErrorSign   guifg=red    guibg=none ctermfg=red    ctermbg=none
          highlight ALEHintSign    guifg=green  guibg=none ctermfg=green  ctermbg=none

          silent !tmux set status off
          set nocursorline
          set noshowcmd
          GitGutterDisable
          Limelight
          " ...
        endfunction

        function! s:goyo_leave()
          highlight ALEInfoSign    guifg=blue   guibg=237 ctermfg=blue   ctermbg=237
          highlight ALEWarningSign guifg=yellow guibg=237 ctermfg=yellow ctermbg=237
          highlight ALEErrorSign   guifg=red    guibg=237 ctermfg=red    ctermbg=237
          highlight ALEHintSign    guifg=green  guibg=237 ctermfg=green  ctermbg=237

          silent !tmux set status on
          set cursorline
          set showmode
          set showcmd
          GitGutterEnable
          Limelight!
          " ...
        endfunction

        autocmd! User GoyoEnter nested call <SID>goyo_enter()
        autocmd! User GoyoLeave nested call <SID>goyo_leave()

        nnoremap <leader>g :Goyo<CR>
    " }}}
    " {{{ firenvim
    " ------------
       if exists('g:started_by_firenvim')
           set laststatus=0
       endif
       let g:firenvim_config = {
      \      'globalSettings': {
      \          'alt': 'all',
      \      },
      \      'localSettings': {
      \          '.*': {
      \              'cmdline': 'firenvim',
      \              'priority': 0,
      \              'selector': 'textarea, div[role="textbox"]',
      \              'takeover': 'never',
      \          },
      \      },
      \}
       au BufEnter bethesda2.cloud.databricks.com_*.txt set filetype=scala
    " }}}

" }}}
