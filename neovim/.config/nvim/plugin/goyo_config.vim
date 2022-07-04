" {{{ Goyo
" --------
    let g:limelight_priority = -1
    let g:limelight_conceal_ctermfg = 240
    let g:limelight_conceal_guifg = 240 " #262626
    let g:limelight_paragraph_span = 0
    function! s:goyo_enter()
      silent !tmux set status off
      let b:sign_status=&signcolumn
      set signcolumn=no
      let b:cursor_line=&cursorline
      set nocursorline
      let b:show_cmd=&showcmd
      set noshowcmd
      TwilightEnable
      " ...
    endfunction

    function! s:goyo_leave()
      silent !tmux set status on
      let &signcolumn=b:sign_status
      let &cursorline=b:cursor_line
      let &showcmd=b:show_cmd
      unlet b:sign_status
      unlet b:cursor_line
      unlet b:show_cmd
      TwilightDisable
      " ...
    endfunction

    autocmd! User GoyoEnter nested call <SID>goyo_enter()
    autocmd! User GoyoLeave nested call <SID>goyo_leave()

    nnoremap <leader>g :Goyo<CR>
" }}}
