set relativenumber
set number
set mouse=a
set virtualedit=all
inoremap jk <Esc>
nnoremap q :q!<CR>
nnoremap ; :
set laststatus=0
colorscheme silverscreen

augroup Everything
    autocmd!
    autocmd TextChanged * normal! G
augroup END
