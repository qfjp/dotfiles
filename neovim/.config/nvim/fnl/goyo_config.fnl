;; {{{ Goyo
;; --------
(import-macros my-macros :macros)

(my-macros.g! limelight_priority -1)
;; 240 -> #262626
(my-macros.g! limelight_conceal_ctermfg 240)
(my-macros.g! limelight_conceal_guifg 240)
(my-macros.g! limelight_paragraph_span 0)

(global GoyoEnterFn
        (fn []
          (vim.cmd "silent !tmux set status off"
                    (my-macros.b! sign_status (my-macros.opt signcolumn)
                        (my-macros.b! cursor_line (my-macros.opt cursorline))
                        (my-macros.b! show_cmd (my-macros.opt showcmd)) (my-macros.set! signcolumn :no)
                        (my-macros.set! nocursorline) (my-macros.set! noshowcmd) (vim.cmd :Twilight)))))

(global GoyoLeaveFn (fn []
                      (vim.cmd "silent !tmux set status on")
                      (my-macros.set! signcolumn (my-macros.b sign_status))
                      (my-macros.set! cursorline (my-macros.b cursor_line))
                      (my-macros.set! showcmd (my-macros.b show_cmd))
                      (vim.cmd "unlet b:sign_status")
                      (vim.cmd "unlet b:cursor_line")
                      (vim.cmd "unlet b:show_cmd")
                      (vim.cmd :TwilightDisable)))

(my-macros.augroup :Goyo
         [(my-macros.autocmd :User :GoyoEnter "call v:lua.GoyoEnterFn()")
          (my-macros.autocmd :User :GoyoLeave "call v:lua.GoyoLeaveFn()")])

;; }}}

