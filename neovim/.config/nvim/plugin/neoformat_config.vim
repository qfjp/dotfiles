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

    let g:neoformat_scala_myscalariform = {
            \ 'exe': 'java',
            \ 'args': ['-jar', $HOME . '/bin/scalariform-0.2.10.jar', '--preferenceFile=' . $HOME . '/.config/scalariform/scalariform.conf' ,'--stdin'],
            \ 'stdin': 1,
            \ }

    let g:neoformat_scala_myscalafmt = {
                \ 'exe' : 'scalafmt',
                \ 'args' : ['--stdin', '--config', $HOME . '/.scalafmt.conf'],
                \ 'stdin' : 1,
                \}

    let g:neoformat_sh_myshfmt = {
                \ 'exe': 'shfmt',
                \ 'args': ['-ln', 'bash', '-i', '4', '-bn'],
                \}
    let g:neoformat_sh_myshfmt = {
                \ 'exe': 'shfmt',
                \ 'args': ['-ln', 'bash', '-i', '2', '-bn'],
                \}

    let g:neoformat_enabled_tex = ['mylatexindent']
    let g:neoformat_enabled_sql = ['mysqlformat']
    let g:neoformat_enabled_scala = ['myscalariform']
    let g:neoformat_enabled_sh = ['myshfmt']
    let g:neoformat_enabled_zsh = []
    let g:neoformat_enabled_c = []
    let g:neoformat_enabled_haskell = []

    " Enable tab to spaces conversion
    let g:neoformat_basic_format_retab = 1

    " Enable trimmming of trailing whitespace
    let g:neoformat_basic_format_trim = 1

    let g:neoformat_run_all_formatters = 1

    "augroup fmt
    "    autocmd!
    "    autocmd BufWritePre * undojoin | Neoformat
    "augroup END
" }}}
