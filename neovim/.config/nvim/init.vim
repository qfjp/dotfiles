scriptencoding utf-8

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
    highlight Search cterm=none gui=none guibg=grey ctermbg=247
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
    highlight SpellCap ctermbg=8
    let g:Guifont = 'Fantasque Sans Mono:10'

    highlight Conceal ctermbg=none
" }}}

" {{{ Greek char maps
" ---------------
    source $HOME/.config/nvim/greek.vim
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
    highlight Folded ctermbg=none ctermfg=magenta cterm=bold

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
        autocmd FileType vim setlocal foldmethod=marker
        autocmd FileType zsh setlocal foldmethod=marker
    augroup END

    set foldtext=FoldText()

    function! FoldText()
        let l:lpadding = &foldcolumn
        redir => l:signs
        execute 'silent sign place buffer='.bufnr('%')
        redir End
        let l:lpadding += l:signs =~? 'id=' ? 2 : 0

        if exists('+relativenumber')
            if (&number)
                let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
            elseif (&relativenumber)
                let l:lpadding += max( [&numberwidth
                                   \ , strlen(v:foldstart + 1 - line('w0'))
                                   \ , strlen(line('w$') - v:foldstart + 1)
                                   \ , strlen(v:foldstart + 1)]) + 1
            endif
        else
            if (&number)
                let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
            endif
        endif

        " expand tabs
        let l:start = substitute( getline(v:foldstart)
                    \           , '\t', repeat(' ', &tabstop), 'g')
        let l:start = substitute(l:start, '["#] *{', '', '')
        let l:start = substitute(l:start, '{{', '', '')
        let l:next = substitute( getline(v:foldstart + 1)
                    \           , '\t', repeat(' ', &tabstop), 'g')
        let l:next = substitute(l:next, ' *" ', '', '')
        let l:end = substitute( substitute( getline(v:foldend)
                  \                       , '\t', repeat(' ', &tabstop), 'g')
                  \           , '^\s*', '', 'g')

        let l:info = l:next .' (' . (v:foldend - v:foldstart + 1) . ')'
        let l:infolen = strlen(substitute(l:info, '.', 'x', 'g'))
        let l:width = winwidth(0) - l:lpadding - l:infolen

        let l:separator = ' … '
        let l:separatorlen = strlen(substitute(l:separator, '.', 'x', 'g'))
        let l:start = strpart( l:start , 0
                    \        , l:width - strlen(substitute( l:end
                    \                                     , '.', 'x', 'g'))
                    \                  - l:separatorlen )

        let l:text = l:start

        return l:text . repeat( ' '
                    \         , l:width - strlen( substitute(l:text
                    \                           , '.', 'x', 'g'))) . l:info
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

    "cnoreabbrev <expr> e getcmdtype() == ":" && getcmdline() == 'e' ? 'tabe' : 'e'
    noremap <C-n> :bnext<CR>
    noremap <C-b> :bprev<CR>
    noremap <leader>n :tabnext<CR>
    noremap <leader>b :tabprev<CR>

    " make line completion easier
    imap <C-l> <C-x><C-l>

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
        autocmd FileType help source ~/.config/nvim/ftplugin/help.vim
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
    call plug#begin('~/.config/nvim/plugged')

    " Vim Wiki
    Plug 'vimwiki/vimwiki'

    " Jupyter Notebooks
    Plug 'bfredl/nvim-ipy'
    Plug 'szymonmaszke/vimpyter'

    " When you type one bracket, you get two
    Plug 'Raimondi/delimitMate'

    " HTML editing
    Plug 'mattn/emmet-vim'

    " Undo tree
    Plug 'mbbill/undotree'

    Plug 'ncm2/ncm2'
    Plug 'roxma/nvim-yarp'

    " NOTE: you need to install completion sources to get completions. Check
    " our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
    Plug 'ncm2/ncm2-bufword'
    Plug 'ncm2/ncm2-path'
    Plug 'ncm2/ncm2-ultisnips'
    Plug 'ncm2/ncm2-tmux'

    " Snippet Engine
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'

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

    Plug 'autozimu/LanguageClient-neovim', {
                \ 'branch': 'next',
                \ 'do': 'bash install.sh',
                \}
    Plug 'junegunn/fzf'

    Plug 'Shougo/echodoc.vim'

    " Autoformatting
    Plug 'sbdchd/neoformat'

    " Nix
    Plug 'LnL7/vim-nix'

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
    Plug 'jreybert/vimagit'

    " Tables
    Plug 'junegunn/vim-easy-align'

    " Clojure and lisps
    Plug 'l04m33/vlime'                    , {'for' : 'lisp', 'rtp' : 'vim/'}
    Plug 'kovisoft/slimv'                  , {'for' : 'scheme'}
                \| Plug 'mbal/swank-racket'
    Plug 'junegunn/rainbow_parentheses.vim', {'for' : ['clojure', 'scheme', 'lisp']}
    Plug 'eraserhd/parinfer-rust', {
                \  'do' : 'cargo build --release'
                \, 'for': ['clojure', 'lisp', 'scheme']
                \}

    " Colorschemes
    Plug 'sickill/vim-monokai'
    Plug 'mhinz/vim-janah'
    Plug 'ElmCast/elm-vim'

    Plug 'rbgrouleff/bclose.vim'

    Plug 'sjbach/Lusty'

    Plug 'junegunn/limelight.vim'
    Plug 'junegunn/goyo.vim'

    Plug 'Vigemus/nvimux'
    Plug 'rliang/termedit.nvim'

    call plug#end()
    " }}}
    colorscheme janah

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
        let g:neoformat_sql_mysqlfmt = {
                \ 'exe': 'sqlfmt',
                \ 'args': ['--use-spaces'],
                \ 'stdin': 1,
                \ }

        let g:neoformat_enabled_python = ['black', 'isort']
        let g:neoformat_enabled_haskell = ['hindent', 'stylishhaskell']
        let g:neoformat_enabled_tex = ['latexindent']
        let g:neoformat_enabled_sql = ["mysqlfmt"]

        " Enable tab to spaces conversion
        let g:neoformat_basic_format_retab = 1

        " Enable trimmming of trailing whitespace
        let g:neoformat_basic_format_trim = 1

        augroup fmt
            autocmd!
            au BufWritePre * try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
        augroup END
    " }}}
    " {{{ Jupyter
    " ------------
        let g:nvim_ipy_perform_mappings = 0
        let g:ipy_celldef = ['^```{.python .input[^{}]*}$', '^```$']
        map <silent> <leader><CR> <Plug>(IPy-RunCell)
    " }}}
    " {{{ Completion
    " -------------
        " suppress the annoying 'match x of y', 'The only match' and 'Pattern not
        " found' messages
        set shortmess+=c

        " CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
        inoremap <c-c> <ESC>

        " When the <Enter> key is pressed while the popup menu is visible, it only
        " hides the menu. Use this mapping to close the menu and also start a new
        " line.
        inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
        inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')

        " Use <TAB> to select the popup menu:
        inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
        inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
        inoremap <C-n> <C-x><C-o>

        " wrap existing omnifunc
        " Note that omnifunc does not run in background and may probably block the
        " editor. If you don't want to be blocked by omnifunc too often, you could
        " add 180ms delay before the omni wrapper:
        "  'on_complete': ['ncm2#on_complete#delay', 180,
        "               \ 'ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
        au User Ncm2Plugin call ncm2#register_source({
                \ 'name' : 'css',
                \ 'priority': 9,
                \ 'subscope_enable': 1,
                \ 'scope': ['css','scss'],
                \ 'mark': 'css',
                \ 'word_pattern': '[\w\-]+',
                \ 'complete_pattern': ':\s*',
                \ 'on_complete': ['ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
                \ })
        au User Ncm2Plugin call ncm2#register_source({
                \ 'name' : 'vimtex',
                \ 'priority': 1,
                \ 'subscope_enable': 1,
                \ 'complete_length': 1,
                \ 'scope': ['tex'],
                \ 'matcher': {'name': 'combine',
                \           'matchers': [
                \               {'name': 'abbrfuzzy', 'key': 'menu'},
                \               {'name': 'prefix', 'key': 'word'},
                \           ]},
                \ 'mark': 'tex',
                \ 'word_pattern': '\w+',
                \ 'complete_pattern': g:vimtex#re#ncm,
                \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
                \ })
        autocmd BufEnter * call ncm2#enable_for_buffer()

        " LaTeX (rubber) macro
        nnoremap <leader>c :w<CR>:!rubber --pdf --warn all %<CR>

        " View PDF macro; '%:r' is current file's root (base) name.
        nnoremap <leader>v :!mupdf %:r.pdf &<CR><CR>

        set completeopt=noinsert,menuone,noselect
        set completefunc=LanguageClient#complete

        let g:LanguageClient_serverCommands = {
            \ 'c': ['cquery', '--log-file=/tmp/cq.log'],
            \ 'cpp': ['cquery', '--log-file=/tmp/cq.log'],
            \ 'haskell': ['hie-wrapper', '--lsp'],
            \ 'tex': ['java', '-jar', '/usr/share/java/texlab/texlab.jar'],
            \ 'python': ['pyls'],
            \ 'rust': ['rls'],
            \ 'scala': ['metals-vim'],
            \ 'scheme': ['racket', '-l', 'racket-langserver'],
            \ }
        let g:LanguageClient_rootMarkers = {
            \ 'scala': ['build.sbt'],
            \ }

        augroup LanguageClient
            autocmd!

            au BufWritePost * sign unplace *
        augroup END


        let g:LanguageClient_diagnosticsDisplay =
                    \{
                    \    1: {
                    \        "name": "Error",
                    \        "texthl": "ALEError",
                    \        "signText": "●",
                    \        "signTexthl": "ALEErrorSign",
                    \        "virtualTexthl": "Error",
                    \    },
                    \    2: {
                    \        "name": "Warning",
                    \        "texthl": "ALEWarning",
                    \        "signText": "●",
                    \        "signTexthl": "ALEWarningSign",
                    \        "virtualTexthl": "Todo",
                    \    },
                    \    3: {
                    \        "name": "Information",
                    \        "texthl": "ALEInfo",
                    \        "signText": "●",
                    \        "signTexthl": "ALEInfoSign",
                    \        "virtualTexthl": "Todo",
                    \    },
                    \    4: {
                    \        "name": "Hint",
                    \        "texthl": "ALEInfo",
                    \        "signText": "●",
                    \        "signTexthl": "ALEHintSign",
                    \        "virtualTexthl": "Todo",
                    \    },
                    \}
        highlight ALEInfoSign    ctermfg=blue   ctermbg=237
        highlight ALEWarningSign ctermfg=yellow ctermbg=237
        highlight ALEErrorSign   ctermfg=red    ctermbg=237
        highlight ALEHintSign    ctermfg=green  ctermbg=237

        nnoremap gm :call LanguageClient_contextMenu()<CR>
        nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
        nnoremap <silent> gK :call LanguageClient#textDocument_definition()<CR>
        nnoremap <silent> gr :call LanguageClient#textDocument_rename()<CR>
        let g:LanguageClient_useVirtualText = 0
    " }}}
    " {{{ UltiSnips
    " -------------
        let g:UltiSnipsExpandTrigger = "<tab>"
        let g:UltiSnipsJumpForwardTrigger='<c-j>'
        let g:UltiSnipsJumpBackwardTrigger  = '<c-k>'
        let g:UltiSnipsSnippetDirectories = [ 'plugged/ultisnips/UltiSnips'
                                          \ , 'bundle/mysnips'
                                          \ ]
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
    " {{{ Python Things
    " -----------------
        augroup Python
            autocmd!

            autocmd FileType python let b:neoformat_run_all_formatters=1
        augroup END
    " }}}
    " {{{ Haskell things
    " -----------------
        let g:no_haskell_conceal = 1
        augroup Haskell
            autocmd!

            autocmd BufNewFile,BufRead *.fr setfiletype frege
            autocmd FileType haskell set cinkeys=0{,0},0),0#,!<Tab>,;,:,o,O,e
            autocmd FileType haskell set indentkeys=!<Tab>,o,O
            autocmd FileType haskell let b:neoformat_run_all_formatters=1
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
        let g:startify_bookmarks = ['~/.config/nvim/init.vim', '~/.zshrc']
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
                    \ $HOME .'.config/nvimrc',
                    \ $HOME .'/.zshrc',
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
        set updatetime=750
    " }}}
    " {{{ Clojure
    " -----------
        let g:rainbow#max_level = 16
        let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
        augroup Clojure
            autocmd!
            autocmd FileType lisp,clojure,scheme RainbowParentheses
        augroup END
    " }}}
    " {{{ Scheme
    " ----------
        let racket_swank = '~/.config/nvim/plugged/swank-racket/'
        let g:slimv_swank_cmd = '! xterm -e "cd ' . racket_swank . '; racket server.rkt" &'
        let g:swank_port = 4005
        let g:slimv_unmap_cr = 1
        let g:slimv_leader = '<space>'
        augroup Scheme
            autocmd!
            autocmd! BufEnter *scm syn clear schemeError
        augroup END
    " }}}
    " {{{ Goyo
    " --------
        let g:limelight_conceal_ctermfg = 240
        function! s:goyo_enter()
          highlight ALEInfoSign    ctermfg=blue   ctermbg=none
          highlight ALEWarningSign ctermfg=yellow ctermbg=none
          highlight ALEErrorSign   ctermfg=red    ctermbg=none
          highlight ALEHintSign    ctermfg=green  ctermbg=none

          silent !tmux set status off
          set nocursorline
          set noshowmode
          set noshowcmd
          set scrolloff=999
          Limelight
          " ...
        endfunction

        function! s:goyo_leave()
          highlight ALEInfoSign    ctermfg=blue   ctermbg=237
          highlight ALEWarningSign ctermfg=yellow ctermbg=237
          highlight ALEErrorSign   ctermfg=red    ctermbg=237
          highlight ALEHintSign    ctermfg=green  ctermbg=237

          silent !tmux set status on
          set cursorline
          set showmode
          set showcmd
          set scrolloff=5
          Limelight!
          " ...
        endfunction

        autocmd! User GoyoEnter nested call <SID>goyo_enter()
        autocmd! User GoyoLeave nested call <SID>goyo_leave()

        nnoremap <leader>g :Goyo<CR>
    " }}}
    " {{{ Nvimux
    " ----------
        lua << EOF
        local nvimux = require('nvimux')

        -- Nvimux configuration
        nvimux.config.set_all{
          prefix = '<C-Space>',
          new_window = 'term',
          new_tab = nil, -- Defaults to new_window. Set to 'term' if you want a new term for every new tab
          new_window_buffer = 'single',
          quickterm_direction = 'botright',
          quickterm_orientation = 'vertical',
          quickterm_scope = 't', -- Use 'g' for global quickterm
          quickterm_size = '80',
        }

        -- Nvimux custom bindings
        nvimux.bindings.bind_all{
          {'s', ':NvimuxHorizontalSplit', {'n', 'v', 'i', 't'}},
          {'v', ':NvimuxVerticalSplit', {'n', 'v', 'i', 't'}},
          {'p', ':NvimuxTermPaste', {'n', 'v', 'i', 't'}},
        }

        -- Required so nvimux sets the mappings correctly
        nvimux.bootstrap()
EOF
    " }}}

" }}}
