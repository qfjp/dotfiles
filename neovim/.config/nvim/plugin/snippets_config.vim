" {{{ Snippets
" -------------
    inoremap <expr> <TAB> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<TAB>'
    snoremap <expr> <TAB> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<TAB>'
    inoremap <expr> <S-TAB> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-TAB>'
    snoremap <expr> <S-TAB> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-TAB>'
" }}}
