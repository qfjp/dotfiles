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
