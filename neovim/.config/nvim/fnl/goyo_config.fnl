;; {{{ Goyo
;; --------
(require-macros :hibiscus.vim)
(local lib (require :lib))
(g! limelight_priority -1)
;; 240 -> #262626
(g! limelight_conceal_ctermfg 240)
(g! limelight_conceal_guifg 240)

(g! limelight_paragraph_span 0)
(fn goyo-enter []
  (vim.cmd "silent !tmux set status off")
  (b! sign_status (lib.opt :signcolumn))
  (b! cursor_line (lib.opt :cursorline))
  (b! show_cmd (lib.opt :showcmd))
  (set! signcolumn :no)
  (set! nocursorline)
  (set! noshowcmd)
  (vim.cmd :TwilightEnable))

(fn goyo-leave []
  (vim.cmd "silent !tmux set status on")
  (set vim.opt.signcolumn (lib.b :sign_status))
  (set vim.opt.cursorline (lib.b :cursor_line))
  (set vim.opt.showcmd (lib.b :show_cmd))
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

