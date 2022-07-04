" {{{ Lightline
    let g:lightline = {
    \ 'active': {
    \   'left': [ [ 'mode', 'paste', 'readonly' ],
    \             [ 'fugitive' ],
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
        let branch = FugitiveHead()
        return branch !=# '' ? ' '.branch : ''
    endfunction

    " bufferline
    let g:lightline#bufferline#filename_modifier = ':t'
    let g:lightline#bufferline#shorten_path = 0
    let g:lightline#bufferline#enable_devicons = 1
    let g:lightline.tabline          = {'left': [['tabs']], 'right': [['buffers']]}
    let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
    let g:lightline.component_type   = {'buffers': 'tabsel'}
    augroup Lightline
        autocmd!
        autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()
    augroup END
" }}}
