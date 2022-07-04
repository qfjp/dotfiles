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
