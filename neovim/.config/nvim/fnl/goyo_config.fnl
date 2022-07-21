;; {{{ Goyo
;; --------
(require-macros :hibiscus.vim)
(require-macros :macros)

(g! limelight_priority -1)
;; 240 -> #262626
(g! limelight_conceal_ctermfg 240)
(g! limelight_conceal_guifg 240)
(g! limelight_paragraph_span 0)

(fn goyo-enter []
  (vim.cmd "silent !tmux set status off")
  (b! sign_status (opt signcolumn))
  (b! cursor_line (opt cursorline))
  (b! show_cmd (opt showcmd))
  (set! signcolumn :no)
  (set! nocursorline)
  (set! noshowcmd)
  (vim.cmd :TwilightEnable))

(fn goyo-leave []
  (vim.cmd "silent !tmux set status on")
  (opt! signcolumn (b sign_status))
  (opt! cursorline (b cursor_line))
  (opt! showcmd (b show_cmd))
  (exec [[:unlet "b:sign_status"]])
  (exec [[:unlet "b:cursor_line"]])
  (exec [[:unlet "b:show_cmd"]])
  (vim.cmd :TwilightDisable))

(augroup! :Goyo [[User :nested]
                 [GoyoEnter]
                 (fn []
                   (goyo-enter))]
          [[User :nested]
           [GoyoLeave]
           (fn []
             (goyo-leave))])

;; }}}

