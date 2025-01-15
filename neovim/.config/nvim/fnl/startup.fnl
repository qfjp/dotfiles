(require-macros :macros)

;; Initialize packer
(let [packer-path (.. (vimfn stdpath :data) :/site/pack/packer/start)
      cmd (io.popen (.. "find " packer-path "* -maxdepth 1"))
      files {}
      packer (require :packer)]
  (each [fname (cmd:lines)]
    (tset files (+ 1 (length files)) fname))
  ((. (require :packer) :startup) (. (require :plugins) :packer_table))
  (when (<= (length files) 5)
    (packer.sync)))

;; {{{ Plugin Configs
;; ------------------

(when (pcall require :transparent)
  (let [transparent (require :transparent)]
    ((. transparent :setup) {:exclude_groups [:Visual]})
    ((. transparent :clear_prefix) :GitSigns)
    ((. transparent :clear_prefix) :Visual)))

(when (pcall require :cmp)
  (require :completion_config))

(when (pcall require :nvim-treesitter)
  (require :treesitter_config))

(when (pcall require :telescope)
  (let [telescope (require :telescope)
        themes (require :telescope.themes)]
    ((. telescope :setup) {:extensions {:opts {}
                                        :picker_list {}
                                        :excluded_pickers {}
                                        :docker {}
                                        :undo {}
                                        :lsp_handlers {:code_action {:telescope ((. themes
                                                                                    :get_dropdown) {})}}}})
    ((. telescope :load_extension) :fzy_native)
    ((. telescope :load_extension) :packer)
    ((. telescope :load_extension) :jj)
    ((. telescope :load_extension) :foldmarkers)
    ((. telescope :load_extension) :texsuite)
    ((. telescope :load_extension) :docker)
    ((. telescope :load_extension) :undo)
    ((. telescope :load_extension) :ports)
    ((. telescope :load_extension) :conventional_commits)
    ((. telescope :load_extension) :lsp_handlers)
    ((. telescope :load_extension) :ht)
    ;; picker_list must be last
    ((. telescope :load_extension) :picker_list)))

(require :startify_config)
(require :goyo_config)

;; }}}

(global GuiSetup
        (fn []
          "Settings for Neovide and Gonvim"
          (do
            (set! guifont "FiraCode Nerd Font:h10")
            (set! showtabline 2)
            (g! neovide_no_idle true)
            (g! neovide_curosr_vfx_mode :wireframe)
            (when (g :goneovim)
              (exec [[GonvimSmoothCursors] [GonvimSmoothScroll]])))))

(when (or (g goneovim) (g neovide))
  (augroup :Gui (autocmd :UIEnter "*" "call v:lua.GuiSetup()")))

(g! mapleader " ")
(g! maplocalleader " ")

;; {{{ Theme
;; ---------
(set! noshowmode)
(set! laststatus 2)
(set! cursorline)
(set! colorcolumn :71)
(set! background :dark)
;; }}}

;; {{{ Greek Char Maps
;; -------------------
(vim.cmd (.. :source (.. (vimfn stdpath :config) :/greek.vim)))

;; }}}

;; {{{ Search Options
;; ------------------
(set! hlsearch)
(set! incsearch)
(set! nowrapscan)
(set! ignorecase)
(set! smartcase)

(global HlNext
        (fn [blinktime]
          (exec [[highlight! link SearchBlink IncSearch]])
          (let [search_text (vim.api.nvim_eval "@/")
                target_pat (.. "\\c\\%#" search_text)
                ring (vimfn matchadd :SearchBlink target_pat 101)
                sleep_str (string.format "%sm" (* blinktime 200))
                call_str (string.format "matchdelete(%s)" ring)]
            (vim.cmd (.. "redraw | sleep " sleep_str " | call " call_str)))))

;; }}}

;; {{{ Indent Options
;; ------------------
(set! autoindent)
(set! smarttab)
(set! expandtab)
(set! tabstop 4)
(set! shiftwidth 4)
(set! textwidth 70)

(set! linebreak)
(set! breakindent)
(set! showbreak "-→")
(g! html_indent_inctags "head,html,body,p,head,table,tbody,div,script")
(g! html_indent_script1 :inc)
(g! html_indent_style1 :inc)
;; }}}

;; {{{ Behaviors
;; -------------
(set! wrap)
(set! linebreak)

(set! undofile)
(set! undodir (.. (os.getenv :HOME) :/.local/share/vim-backup))
(set! scrolloff 5)
(set! autochdir)

(set! history 1000)
(set! undolevels 1000)

(set! mouse "")

(set! backspace [:indent :eol :start])
(set+ cpoptions "$")

(set! ruler)
(set! title)
(set! autoread)
(set! wildmenu)

(set! hidden)
(set! formatoptions :coq2)

(augroup :QFixToggle
         (autocmd :BufWinEnter :quickfix
                  "let g:qfix_win=bufnr(\"$\")|set nolist|set colorcolumn=0")
         (autocmd :BufWinLeave :quickfix
                  "if exists(\"g:qfix_win\") && g:qfix_win == expand(\"<abuf>\")|unlet! g:qfix_win|endif"))

(fn ScratchBuf []
  (var scratchname :scratch)
  (var scratchbuf (vimfn bufnr scratchname))
  (when (= -1 scratchbuf)
    (do
      (set scratchbuf (vim.api.nvim_create_buf true true))
      (vim.api.nvim_buf_set_name scratchbuf scratchname)))
  (vim.api.nvim_win_set_buf 0 scratchbuf)
  (set vim.opt_local.buftype :nofile)
  (set vim.opt_local.bufhidden :hide)
  (set vim.opt_local.swapfile false))

(defcommand :Scratch ScratchBuf)
;; }}}

;; {{{ Visual
;; ----------
(set! showmatch)
(set! list)
(set! conceallevel 0)

(fn MatchHighIp [str]
  "True if an IP address is above '3' on the local network"
  (let [subnet :192.168.1.]
    (or (string.match str (.. subnet "[4-9]"))
        (string.match str (.. subnet "[1-9][0-9]"))
        (string.match str (.. subnet "[1-2][0-9][0-9]")))))

(set! termguicolors)

(set! listchars "tab:▕░,trail:▒,extends:>,precedes:<")

;; }}}

;; {{{ Nvim Terminal mode
;; ----------------------
(set vim.env.NVIM_LISTEN_ADDRESS vim.v.servername)

(global TermOptions (fn []
                      (do
                        (set! filetype :terminal)
                        ;; Black
                        (b! terminal_color_0 "#1A1919")
                        (b! terminal_color_8 "#75715e")
                        ;; Red
                        (b! terminal_color_1 "#f92672")
                        (b! terminal_color_9 "#f92672")
                        ;; Green
                        (b! terminal_color_2 "#a6e22e")
                        (b! terminal_color_10 "#a6e22e")
                        ;; Yellow
                        (b! terminal_color_3 "#f4bf75")
                        (b! terminal_color_11 "#f4bf75")
                        ;; Blue
                        (b! terminal_color_4 "#66d9ef")
                        (b! terminal_color_12 "#66d9ef")
                        ;; Magenta
                        (b! terminal_color_5 "#ae81ff")
                        (b! terminal_color_13 "#ae81ff")
                        ;; Cyan
                        (b! terminal_color_6 "#a1efe4")
                        (b! terminal_color_14 "#a1efe4")
                        ;; White
                        (b! terminal_color_7 "#989892")
                        (b! terminal_color_15 "#f9f8f5"))))

(augroup :Terminal (autocmd :TermOpen "*" "call v:lua.TermOptions()"))

;; }}}

;; {{{ Folds
;; ---------
(set! foldcolumn :0)
(set! foldlevelstart 99)

(rem! viewoptions :options)

(augroup :Folds
         (autocmd :FileType "vim,zsh,lua,fennel"
                  "set foldmethod=marker|set foldtext=v:lua.SimpleFoldText()"))

(set! foldtext "v:lua.CFoldText()")

(fn PadToRight [lstring rstring]
  (let [width (vimfn winwidth ".")
        offset (string.rep " " (- width (string.len (.. lstring rstring))))]
    (.. lstring offset rstring)))

(global SimpleFoldText (fn []
                         (let [ell " ⋯ "
                               vstart (vimfn getline vim.v.foldstart)
                               vend (vimfn trim (vimfn getline vim.v.foldened))
                               startpattern "^%s*[\"#-;]+%-?%s*{{{"
                               endpattern "^%s*[\"#-;]+%-?%s*}}}"
                               vstartPrime (string.gsub vstart startpattern "")
                               vendPrime (string.gsub vend endpattern "")
                               linestring (.. " === "
                                              (table.maxn (vimfn getline
                                                                 vim.v.foldstart
                                                                 vim.v.foldend))
                                              " lines === ")]
                           (PadToRight (.. vstartPrime " " ell " " vendPrime)
                                       linestring))))

(global CFoldText
        (fn []
          (let [ell " ⋯ "
                lines (vimfn getline vim.v.foldstart vim.v.foldend)
                size (table.maxn lines)
                linestring (.. " === " size " lines === ")
                vstart (vimfn getline vim.v.foldstart)]
            (if (or (string.match vstart "{$") (string.match vstart "-$"))
                (PadToRight (.. vstart ell
                                (vimfn trim (vimfn getline vim.v.foldend)))
                            linestring)
                (do
                  (var had_comma false)
                  (var new_lines {})
                  (var done false)
                  (each [ix line (pairs lines)]
                    (when (not done)
                      (var curline line)
                      (when (not= ix 1)
                        (do
                          (set curline (vimfn trim curline))
                          (set curline (string.gsub curline "%s+" " "))))
                      (when had_comma
                        (set curline (.. " " curline))
                        (set had_comma false))
                      (when (string.match curline ",$")
                        (set had_comma true))
                      (tset new_lines ix curline)
                      (when (string.match line "%)%s*:.*=%s*")
                        (tset new_lines ix ")")
                        (set done true))))
                  (PadToRight (table.concat new_lines) linestring))))))

;; }}}

;; {{{ Keymaps
;; -----------

;; Which-key nowait is broken?
(vim.api.nvim_set_keymap :c :<C-a> :<Home> {:nowait true})
(vim.api.nvim_set_keymap :c :<C-e> :<End> {:nowait true})
(vim.api.nvim_set_keymap :c :<C-f> :<Right> {:nowait true})
(vim.api.nvim_set_keymap :c :<C-b> :<Left> {:nowait true})
(vim.api.nvim_set_keymap :c :<ESC>b :<Home> {:nowait true})
(vim.api.nvim_set_keymap :c :<ESC>f :<End> {:nowait true})
(vim.api.nvim_set_keymap :c "w;" :w<CR> {:nowait true})

(when (pcall require :which-key)
  (let [wk package.loaded.which-key
        t (fn [str]
            (vim.api.nvim_replace_termcodes str true true true))]
    ;; Command
    (wk.add {:mode [:c]
             1 {1 :s :group :Sayonara :silent false}
             2 {1 "s;"
                2 :Sayonara!<CR>
                :desc "Forget File Buffer"
                :silent false}
             3 {1 "sa;"
                2 :Sayonara<CR>
                :desc "Forget File Buffer And Layout"
                :silent false}})
    ;; Visual
    (wk.add {:mode [:v]
             1 {1 :J 2 ":m '>+1<CR>gv=gv" :desc "Move line up"}
             2 {1 :K 2 ":m '<-2<CR>gv=gv" :desc "Move line down"}})
    ;; Visual + Normal
    (wk.add {:mode [:n :v]
             1 {1 :gk 2 :k :desc "Move up one actual line"}
             2 {1 :gj 2 :j :desc "Move down one actual line"}
             3 {1 :g0
                2 :0
                :desc "Move to the beginning of the current (actual) line"}
             4 {1 :g$
                2 "$"
                :desc "Move to the end of the current (actual) line"}
             5 {1 :k 2 :gk :desc "Move up one visual line"}
             6 {1 :j 2 :gj :desc "Move down one visual line"}
             7 {1 :0
                2 :g0
                :desc "Move to the beginning of the current (visual) line"}
             8 {1 "$"
                2 :g$
                :desc "Move to the end of the current (visual) line"}
             9 {1 :<C-f>
                2 ":TSHighlightCapturesUnderCursor<CR>"
                :desc "Show highlight group"}
             10 {1 :<F10>
                 2 ":TSHighlightCapturesUnderCursor<CR>"
                 :desc "Show highlight group"}
             11 {1 :<C-n> 2 ":bnext<CR>" :desc "Next buffer"}
             12 {1 :<C-b> 2 ":bprev<CR>" :desc "Prev Buffer"}
             13 {1 "'" 2 "`" :desc "Jump to mark"}
             14 {1 "`" 2 "'" :desc "Jump to mark^"}
             16 {1 :z :group :Folds :silent false}
             17 {1 "z["
                 2 (. (require :ufo) :openAllFolds)
                 :desc "Open all folds"}
             18 {1 "z]"
                 2 (. (require :ufo) :closeAllFolds)
                 :desc "Close all folds"}
             19 {1 :<C-s> 2 ":Scratch<CR>" :desc "Scratch Buffer"}
             20 {1 :<C-h>
                 2 ":TmuxNavigateLeft<CR>"
                 :desc "Select Window/Pane Left"}
             21 {1 :<C-l>
                 2 ":TmuxNavigateRight<CR>"
                 :desc "Select Window/Pane Right"}
             22 {1 :<C-k>
                 2 ":TmuxNavigateUp<CR>"
                 :desc "Select Window/Pane Down"}
             23 {1 :<C-j>
                 2 ":TmuxNavigateDown<CR>"
                 :desc "Select Window/Pane Up"}
             24 {1 :n 2 "n:lua HlNext(0.4)<CR>" :desc "Glow Next"}
             25 {1 :N 2 "N:lua HlNext(0.4)<CR>" :desc "Glow Prev"}
             26 {1 ";" 2 ":" :desc "Quick Command"}})
    ;; Normal
    (wk.add {:mode [:n]
             1 {1 :gf 2 ":e <cfile><CR>" :desc "Open file (always)"}
             2 {1 :gd :group "Vim Diagnostic" :silent false}
             3 {1 :gdf
                2 #(vim.diagnostic.open_float)
                :desc "Open diagnostic options"}
             4 {1 :gdn
                2 #(vim.diagnostic.goto_next)
                :desc "Goto next error/warning"}
             5 {1 :gdp
                2 #(vim.diagnostic.goto_prev)
                :desc "Goto prev error/warning"}
             6 {1 :gdh 2 #(vim.diagnostic.hide) :desc "Hide diagnostics"}
             7 {1 :gds 2 #(vim.diagnostic.show) :desc "Show diagnostics"}
             8 {1 :gl :group "Vim LSP" :silent false}
             9 {1 :gla 2 #(vim.lsp.buf.code_action) :desc "Code actions"}
             10 {1 :gld 2 #(vim.lsp.buf.definition) :desc "Show definition"}
             11 {1 :glD 2 #(vim.lsp.buf.declaration) :desc "Show declaration"}
             12 {1 :gle
                 2 #(vim.diagnostic.open_float)
                 :desc "Show error messages"}
             13 {1 :glf
                 2 #(vim.diagnostic.open_float)
                 :desc "Open diagnostic options"}
             14 {1 :glh 2 #(vim.lsp.buf.hover) :desc "LSP Hover"}
             15 {1 :gli
                 2 #(vim.lsp.buf.implementation)
                 :desc "Show implementation"}
             16 {1 :gll
                 2 #(vim.lsp.util.show_line_diagnostics)
                 :desc "Show line diagnostics"}
             17 {1 :gln
                 2 #(vim.diagnostic.goto_next)
                 :desc "Goto next error/warning"}
             18 {1 :glp
                 2 #(vim.diagnostic.goto_prev)
                 :desc "Goto prev error/warning"}
             19 {1 :gls
                 2 #(vim.diagnostic.signature_help)
                 :desc "Show signature"}
             20 {1 :glt
                 2 #(vim.lsp.buf.type_definition)
                 :desc "Show type definition"}
             21 {1 :gK 2 #(vim.lsp.buf.hover) :desc "LSP Hover"}
             22 {1 :go :group "Git Signs" :silent false}
             23 {1 :gon
                 2 #(package.loaded.gitsigns.next_hunk)
                 :desc "Next hunk"}
             24 {1 :gop
                 2 #(package.loaded.gitsigns.prev_hunk)
                 :desc "Prev hunk"}
             25 {1 :goP
                 2 #(package.loaded.gitsigns.preview_hunk)
                 :desc "Preview hunk"}
             26 {1 :gol
                 2 #(package.loaded.gitsigns.blame_line {:full true})
                 :desc "Full blame"}
             27 {1 :got
                 2 #(package.loaded.gitsigns.toggle_current_line_blame)
                 :desc "Toggle line blame"}
             28 {1 :god
                 2 #(package.loaded.gitsigns.diffthis)
                 :desc "Split diff"}
             29 {1 :goD
                 2 #(package.loaded.gitsigns.toggle_deleted)
                 :desc "Show deleted lines"}
             30 {1 :g<leader>c 2 ":set spell!<CR>" :desc "Spell checker"}
             31 {1 :g<leader>n 2 ":tabnext<CR>" :desc "Next tab"}
             32 {1 :g<leader>b 2 ":tabprev<CR>" :desc "Prev tab"}
             33 {1 :g<leader>G 2 ":Goyo<CR>" :desc "Focused Editing"}
             34 {1 :g<leader>l :group "Lusty Juggler" :silent false}
             35 {1 :g<leader>dt
                 2 "<C-\\><C-n>:SSave! default | qall<CR>"
                 :desc "Save default session and quit"}
             36 {1 :g<leader>s 2 ":split<CR>" :desc "Split window (H)"}
             36 {1 :g<leader>s 2 ":split<CR>" :desc "Split window (H)"}
             37 {1 :g<leader>v
                 2 ":vertical split<CR>"
                 :desc "Split window (V)"}
             38 {1 :g<leader>= 2 :<C-w>= :desc "Equally high and wide"}
             39 {1 :g<leader>+
                 2 ":vertical resize +10<CR>"
                 :desc "Increase height"}
             40 {1 :g<leader>-
                 2 ":vertical resize -10<CR>"
                 :desc "Decrease height"}
             41 {1 :g<leader>>
                 2 ":vertical resize +10<CR>"
                 :desc "Increase width"}
             42 {1 :g<leader><
                 2 ":vertical resize -10<CR>"
                 :desc "Decrease width"}
             43 {1 :g<leader>l
                 2 ":vertical resize +10<CR>"
                 :desc "Grow window (V)"}
             44 {1 :g<leader>dt
                 2 ":SSave! default | qall<CR>"
                 :desc "Save default session and quit"}
             45 {1 :g<leader>Dt
                 2 ":SLoad default<CR>"
                 :desc "Load default session"}
             46 {1 :<C-f>
                 2 ":TSHighlightCapturesUnderCursor<CR>"
                 :desc "Show highlight group"}
             47 {1 :<F10>
                 2 ":TSHighlightCapturesUnderCursor<CR>"
                 :desc "Show highlight group"}
             48 {1 :<C-n> 2 ":bnext<CR>" :desc "Next buffer"}
             49 {1 :<C-b> 2 ":bprev<CR>" :desc "Prev Buffer"}
             50 {1 "'" 2 "`" :desc "Jump to mark"}
             51 {1 "`" 2 "'" :desc "Jump to mark^"}})
    ;; Insert
    (wk.add (let [cmp (require :cmp)
                  types (require :cmp.types)
                  nextfn #(if ((. cmp :visible))
                              ((. cmp :select_next_item) {:behavior types.cmp.SelectBehavior.Insert})
                              ((. cmp :complete)))]
              {:mode [:i]
               1 {1 :<C-j> 2 nextfn}
               2 {1 :<C-n> 2 nextfn}
               3 {1 :<Tab>
                  2 #(if ((. cmp :visible))
                         ((. cmp :select_next_item))
                         (vim.cmd "call feedkeys(\"\\<Tab>\", \"n\")"))}
               4 {1 :<S-Tab>
                  2 #(if ((. cmp :visible))
                         ((. cmp :select_prev_item))
                         ((. cmp :complete)))}
               5 {1 :jk 2 :<Esc> :desc "Quick escape"}
               6 {1 :<C-k> 2 :<C-p> :desc "Prev item"}}))
    ;; Terminal
    (wk.add {:mode :t
             1 {1 :<C-Space> :group "Tmux prefix-alike" :silent false}
             2 {1 :<C-Space>vt 2 "<C-\\><C-n><C-w>v" :desc "Split vertically"}
             3 {1 :<C-Space>ht
                2 "<C-\\><C-n><C-w>s"
                :desc "Split horizontally"}
             4 {1 :<C-Space>dt
                2 "<C-\\><C-n>SSave! default | qall<CR>"
                :desc "Save default session and quit"}
             5 {1 :<C-Space>Dt
                2 "<C-\\><C-n>:SLoad default<CR>"
                :desc "Load default session"}
             6 {1 :<C-v>t 2 "<C-\\><C-n><C-w>v" :desc "Split vertically"}
             7 {1 :<C-s>t 2 "<C-\\><C-n><C-w>v" :desc "Split vertically"}
             8 {1 :<C-k>t 2 "<C-\\><C-n><C-w>k" :desc "Move to window above"}
             9 {1 :<C-j>t 2 "<C-\\><C-n><C-w>j" :desc "Move to window below"}
             10 {1 :<C-h>t 2 "<C-\\><C-n><C-w>h" :desc "Move to window left"}
             11 {1 :<C-l>t 2 "<C-\\><C-n><C-w>l" :desc "Move to window right"}
             ;; Vim as Tmux-alike
             12 {1 :<C-w> :name :+window}
             13 {1 :<C-w>c 2 ":tabnew<CR>" :desc "Create new tab"}
             14 {1 :<C-w>n 2 ":tabnext<CR>" :desc "Next Tab"}
             15 {1 :<C-w>b 2 ":tabprev<CR>" :desc "Prev Tab"}
             16 {1 :<C-w>+
                 2 ":vertical resize +10<CR>"
                 :desc "Increase height"}
             17 {1 :<C-w>-
                 2 ":vertical resize -10<CR>"
                 :desc "Decrease height"}
             18 {1 :<C-w>> 2 ":resize +10<CR>" :desc "Increase width"}
             19 {1 :<C-w>< 2 ":resize -10<CR>" :desc "Decrease width"}
             20 {1 :<C-w>d
                 2 ":SSave! default | qall<CR>"
                 :desc "Save default session and quit"}
             21 {1 :<C-w>D 2 ":SLoad default<CR>" :desc "Load default session"}
             22 {1 :<C-Space> :name :+window}
             23 {1 :<C-Space>c 2 ":tabnew<CR>" :desc "Create new tab"}
             24 {1 :<C-Space>n 2 ":tabnext<CR>" :desc "Next Tab"}
             25 {1 :<C-Space>b 2 ":tabprev<CR>" :desc "Prev Tab"}
             26 {1 :<C-Space>s 2 ":split<CR>" :desc "Split Window (H)"}
             27 {1 :<C-Space>v
                 2 ":vertical split<CR>"
                 :desc "Split Window (V)"}
             28 {1 :<C-Space>= 2 :<C-w>= :desc "Equally high and wide"}
             29 {1 :<C-Space>+
                 2 ":vertical resize +10<CR>"
                 :desc "Increase height"}
             30 {1 :<C-Space>-
                 2 ":vertical resize -10<CR>"
                 :desc "Decrease height"}
             31 {1 :<C-Space>>
                 2 ":vertical resize +10<CR>"
                 :desc "Increase width"}
             32 {1 :<C-Space><
                 2 ":vertical resize -10<CR>"
                 :desc "Decrease width"}
             33 {1 :<C-Space>l
                 2 ":vertical resize +10<CR>"
                 :desc "Grow Window (V)"}
             45 {1 :<C-Space>d 2 ":SSave! default | qall<CR>"}
             34 "Save default session and quit"
             35 {1 :<C-Space>D
                 2 ":SLoad default<CR>"
                 :desc "Load default session"}})))

;(wk.register
;; Vim as Tmux-alike
;;:<C-f> [":TSHighlightCapturesUnderCursor<CR>"
;;        "Show Highlight Group"
;;:<F10> [":TSHighlightCapturesUnderCursor<CR>"
;;        "Show Highlight Group"]
;;:<C-n> [":bnext<CR>" "Next Buffer"]
;;:<C-b> [":bprev<CR>" "Prev Buffer"]
;;"'" ["`" "Jump to mark"]
;;"`" ["'" "Jump to mark^"]
;:k [:gk "Move up one visual line"]
;:j [:gj "Move down one visual line"]
;:0 [:g0 "Move to the beginning of the current (visual) line"]
;:$ [:g$ "Move to the end of the current (visual) line"]
;:<C-s> [":Scratch<CR>" "Scratch Buffer"]
;:<C-h> [":TmuxNavigateLeft<CR>" "Select Window/Pane Left"]
;:<C-l> [":TmuxNavigateRight<CR>" "Select Window/Pane Right"]
;:<C-k> [":TmuxNavigateUp<CR>" "Select Window/Pane Down"]
;:<C-j> [":TmuxNavigateDown<CR>" "Select Window/Pane Up"]
;:n ["n:lua HlNext(0.4)<CR>" "Glow Next"]
;:N ["N:lua HlNext(0.4)<CR>" "Glow Prev"])
;;";" [":" "Quick Command"]} {:mode :n})
;; Insert
;(wk.register {:jk [:<Esc> "Quick Escape"] :<C-k> [:<C-p> "Prev Item"]} {:mode :i})))

;; }}}

;; {{{ Auto Commands
;; -----------------
; Open at last line
(augroup :Utilities
         (autocmd :BufReadPost "*"
                  "if line(\"'\\\"\") > 1 && line(\"'\\\"\") <= line(\"$\") | exe \"normal! g`\\\"\" | endif"))

(augroup :LatexHelp (autocmd :FileType :tex "set fileencoding=ascii"))

(global SourceHelp (fn []
                     "Source custom ftplugin"
                     (vim.cmd (.. "source " (vimfn stdpath :config)
                                  :/ftplugin/help.vim))))

(augroup :HelpFiles (autocmd :FileType "call v:lua.SourceHelp()"))

(augroup :Scala (autocmd "BufNewFile,BufRead" :*.sc "set ft=scala"))

;; }}}

;; {{{ netrw
;; ---------
(g! netrw_browse_split 4)
(g! netrw_altv 1)
(g! netrw_list_hide "^\\.")
(g! netrw_hide 1)
;; }}}

(vim.cmd "colorscheme silverscreen")

(require :neoformat_config)

