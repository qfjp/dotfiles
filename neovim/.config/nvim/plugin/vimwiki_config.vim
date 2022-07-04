" {{{ VimWiki
" -----------
    augroup Wiki
        autocmd!
        autocmd FileType vimwiki nmap <silent><buffer> <leader>wt <Plug>VimwikiToggleListItem
        autocmd FileType vimwiki nmap <silent><buffer> <CR> <Plug>VimwikiTabnewLink
    augroup END
" }}}
