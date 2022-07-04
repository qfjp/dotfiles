let git_path = $HOME . '/projects/github/dotfiles/'
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
    let g:startify_bookmarks = [stdpath('config') . '/init.lua', $HOME . '/.zshrc']
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
                \ stdpath('config') . '/init.lua',
                \ $HOME . '/.zshrc',
                \ git_path . 'neovim/.config/nvim/init.lua',
                \ git_path . 'zsh/.zshrc'
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
