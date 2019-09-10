if did_filetype()
  finish
endif

if getline(1) =~ "^#!*gnuplot*"
  setfiletype gnuplot
endif

augroup filetypedetect
  "Mail
  autocmd BufRead,BufNewFile *mutt-*     setfiletype mail
  autocmd BufRead,BufNewFile *.gp        setfiletype gnuplot
  autocmd BufRead,BufNewFile elinks.conf setfiletype elinks
  autocmd BufRead,BufNewFile *.mcn       setfiletype imcnp
  autocmd BufRead,BufNewFile *tmux.conf  setfiletype tmux
augroup END
