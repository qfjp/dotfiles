(require-macros :macros)

(local lualine-conf (let [theme-name :silverscreen
                          mod_color "#b4695e"
                          theme (when (pcall require
                                             (.. :lualine.themes. theme-name))
                                  (require (.. :lualine.themes. theme-name)))
                          inactive-bg (when (not (= nil theme))
                                        theme.inactive.a.bg)
                          inactive-fg (when (not (= nil theme))
                                        theme.inactive.a.fg)
                          ro-fn (fn []
                                  "Show readonly"
                                  (or (and (bo readonly) "") ""))
                          only-whitespace (fn [str]
                                            "Replace str with spaces (use for inactive components)"
                                            (string.gsub str "." " "))]
                      {:options {:icons_enabled true
                                 :theme theme-name
                                 :section_separators {:left "" :right ""}
                                 :component_separators {:left ""
                                                        :right ""}
                                 :always_divide_middle true
                                 :globalstatus false}
                       :sections {:lualine_a [(fn []
                                                "Show paste mode"
                                                (or (and (opt-local paste) "Þ")
                                                    ""))
                                              :mode]
                                  :lualine_b [{1 :buffers
                                               :icons_enabled false
                                               :buffers_color {:active (fn []
                                                                         {:bg (and (bo modified)
                                                                                   mod_color)
                                                                          :fg nil
                                                                          :gui :none})
                                                               :inactive (fn []
                                                                           {:bg inactive-bg
                                                                            :fg inactive-fg
                                                                            :gui :none})}
                                               :symbols {:modified " ●"
                                                         :alternate_file ""
                                                         :directory ""}}]
                                  :lualine_c []
                                  :lualine_x [:diagnostics]
                                  :lualine_y [:encoding
                                              :fileformat
                                              :filetype
                                              {1 ro-fn :color {:fg mod_color}}]
                                  :lualine_z [{1 :progress
                                               :padding {:left 1 :right 1}
                                               :separator " "}
                                              {1 :location
                                               :padding {:left 1 :right 1}
                                               :color {:gui :none}}]}
                       :tabline {:lualine_a [:tabs]
                                 :lualine_b []
                                 :lualine_c []
                                 :lualine_x []
                                 :lualine_y [:diff]
                                 :lualine_z [:branch]}
                       :inactive_sections {:lualine_a [{1 :mode
                                                        :fmt only-whitespace
                                                        :separator " "}]
                                           :lualine_b []
                                           :lualine_c [{1 :filename
                                                        :symbols {:modified " ●"
                                                                  :readonly "  "}
                                                        :padding 2}]
                                           :lualine_x [:ro-fn
                                                       {1 :progress
                                                        :padding {:left 1
                                                                  :right 1}
                                                        :separator " "}
                                                       {1 :location
                                                        :padding {:left 1
                                                                  :right 1}}]
                                           :lualine_y []
                                           :lualine_z []}
                       :extensions []}))

{: lualine-conf}

