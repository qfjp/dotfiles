(require-macros :hibiscus.core)
(require-macros :hibiscus.vim)
(g! neoformat_sql_mysqlformat {:args [:-k
                                      :upper
                                      :--reindent
                                      :--comma_first
                                      :True
                                      "-"]
                               :exe :sqlformat
                               :stdin 1})

(g! neoformat_tex_mylatexindent {:args [:-m :-sl "-g /dev/stderr" :2>/dev/null]
                                 :exe :latexindent
                                 :stdin 1})

(g! neoformat_scala_myscalariform {:args [:-jar
                                          (.. (os.getenv :HOME)
                                              :/bin/scalariform-0.2.10.jar)
                                          (.. :--preferenceFile=
                                              (os.getenv :HOME)
                                              :/.config/scalariform/scalariform.conf
                                              :--stdin)]
                                   :exe :java
                                   :stdin 1})

(g! neoformat_scala_myscalafmt {:args [:--stdin
                                       :--config
                                       (.. (os.getenv :HOME) :/.scalafmt.conf)]
                                :exe :scalafmt
                                :stdin 1})

(g! neoformat_sh_myshfmt {:args [:-ln :bash :-i :4 :-bn] :exe :shfmt})

(g! neoformat_fennel_fnlfmt {:exe :fnlfmt})

(g! neoformat_enabled_tex [:mylatexindent])
(g! neoformat_enabled_sql [:mysqlformat])
(g! neoformat_enabled_scala [:myscalariform])
(g! neoformat_enabled_sh [:myshfmt])
(g! neoformat_enabled_zsh [])
(g! neoformat_enabled_c [])
(g! neoformat_enabled_haskell [])
(g! neoformat_enabled_fennel [:fnlfmt])

(g! neoformat_basic_format_retab 1)

; tabs->spaces
(g! neoformat_basic_format_trim 1)

;trim whitespace
(g! neoformat_run_all_formatters 1)
(augroup! :Fmt [[BufWritePre] "*" "undojoin | Neoformat"])

