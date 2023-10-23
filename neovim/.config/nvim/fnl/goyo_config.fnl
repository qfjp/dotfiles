;; {{{ Goyo
;; --------
(require-macros :macros)

(g! limelight_priority -1)
;; 240 -> #262626
(g! limelight_conceal_ctermfg 240)
(g! limelight_conceal_guifg 240)
(g! limelight_paragraph_span 0)

(global GoyoEnterFn
        (fn []
          (vim.cmd "silent !tmux set status off"
                   (b! sign_status (opt signcolumn)
                       (b! cursor_line (opt cursorline))
                       (b! show_cmd (opt showcmd)) (set! signcolumn :no)
                       (set! nocursorline) (set! noshowcmd) (vim.cmd :Twilight)))))

(global GoyoLeaveFn (fn []
                      (vim.cmd "silent !tmux set status on")
                      (set! signcolumn (b sign_status))
                      (set! cursorline (b cursor_line))
                      (set! showcmd (b show_cmd))
                      (vim.cmd "unlet b:sign_status")
                      (vim.cmd "unlet b:cursor_line")
                      (vim.cmd "unlet b:show_cmd")
                      (vim.cmd :TwilightDisable)))

(augroup :Goyo
         [(autocmd :User :GoyoEnter "call v:lua.GoyoEnterFn()")
          (autocmd :User :GoyoLeave "call v:lua.GoyoLeaveFn()")])

;; }}}

