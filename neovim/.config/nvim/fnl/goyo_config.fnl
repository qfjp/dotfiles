;; {{{ Goyo
;; --------
(require-macros :macros)
(require-macros :zest.macros)

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
  (set! signcolumn (b sign_status))
  (set! cursorline (b cursor_line))
  (set! showcmd (b show_cmd))
  (vim.cmd "unlet \"b:sign_status\"")
  (vim.cmd "unlet \"b:cursor_line\"")
  (vim.cmd "unlet \"b:show_cmd\"")
  (vim.cmd :TwilightDisable))

(def-augroup :Goyo (def-autocmd-fn [:User] [:GoyoEnter] goyo-enter)
             (def-autocmd-fn [:User] [:GoyoLeave] goyo-leave))


;; }}}

