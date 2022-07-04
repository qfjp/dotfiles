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
