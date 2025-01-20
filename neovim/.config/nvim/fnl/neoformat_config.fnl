(import-macros my-macros :macros)
(my-macros.g! neoformat_sql_mysqlformat {:args [:-k
                                                :upper
                                                :--reindent
                                                :--comma_first
                                                :True
                                                "-"]
                                         :exe :sqlformat
                                         :stdin 1})

(my-macros.g! neoformat_tex_mylatexindent {:args [:-m :-sl "-g /dev/stderr" :2>/dev/null]
                                           :exe :latexindent
                                           :stdin 1})

(my-macros.g! neoformat_scala_myscalariform {:args [:-jar
                                                    (.. (os.getenv :HOME)
                                                        :/bin/scalariform-0.2.10.jar)
                                                    (.. :--preferenceFile=
                                                        (os.getenv :HOME)
                                                        :/.config/scalariform/scalariform.conf
                                                        :--stdin)]
                                             :exe :java
                                             :stdin 1})

(my-macros.g! neoformat_scala_myscalafmt {:args [:--stdin
                                                 :--config
                                                 (.. (os.getenv :HOME) :/.scalafmt.conf)]
                                          :exe :scalafmt
                                          :stdin 1})

(my-macros.g! neoformat_sh_myshfmt {:args [:-ln :bash :-i :4 :-bn] :exe :shfmt})

(my-macros.g! neoformat_fennel_fnlfmt {:exe :fnlfmt})

(my-macros.g! neoformat_enabled_tex [:mylatexindent])
(my-macros.g! neoformat_enabled_sql [:mysqlformat])
(my-macros.g! neoformat_enabled_scala [:myscalariform])
(my-macros.g! neoformat_enabled_sh [:myshfmt])
(my-macros.g! neoformat_enabled_zsh [])
(my-macros.g! neoformat_enabled_c [])
(my-macros.g! neoformat_enabled_haskell [])
(my-macros.g! neoformat_enabled_fennel [])

(my-macros.g! neoformat_basic_format_retab 1)

; tabs->spaces
(my-macros.g! neoformat_basic_format_trim 1)

;trim whitespace
(my-macros.g! neoformat_run_all_formatters 1)

(my-macros.augroup :Fmt (my-macros.autocmd :BufWritePre "*" "undojoin | lua vim.lsp.buf.format()"))
;         (autocmd :BufWritePre :*fnl "undojoin | Neoformat"))
