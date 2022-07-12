(require-macros :hibiscus.core)
(require-macros :hibiscus.vim)

(fn g [var_name]
  "Create a global var"
  (. vim.g var_name))

(fn vimfn [func_name ...]
  "Use a vim function"
  ((. vim.fn func_name) ...))

(fn RequireAnd [mod func]
  "Reload module cache, then call function"
  ((. (require :plenary.reload) :reload_module) mod)
  ((. (require mod) func)))

(fn Require [mod]
  "Reload module cache"
  ((. (require :plenary.reload) :reload_module) mod)
  (require mod))

;; {{{ Plugin Configs
;; ------------------
(when (pcall require :cmp)
  (require :completion_config))

(when (pcall require :gitsigns)
  (require :gitsigns_config))

(when (pcall require :nvim-treesitter)
  (require :treesitter_config))

;; }}}

(when (or (g :goneovim) (g :neovide))
  (augroup! :Gui [[UIEnter]
                  *
                  (fn []
                    "Settings for Neovide and Gonvim"
                    (set! guifont "FiraCode Nerd Font:h10")
                    (set! laststatus 2)
                    (set! showtabline 2)
                    (g! neovide_no_idle true)
                    (g! neovide_cursor_vfx_mode :wireframe)
                    (when (g :goneovim)
                      (exec [GonvimSmoothCursor])
                      (exec [GonvimSmoothScroll])))]))

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
(exec [[:source (.. (vimfn :stdpath :config) :/greek.vim)]])

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
          (exec [[:highlight
                  :SearchBlink
                  :guifg=white
                  :guibg=magenta
                  :ctermfg=white
                  :ctermbg=red]])
          (let [search_text (vim.api.nvim_eval "@/")
                target_pat (.. "\\c\\%#" search_text)
                ring (vimfn :matchadd :SearchBlink target_pat 101)
                sleep_str (string.format "%sm" (* blinktime 200))
                call_str (string.format "matchdelete(%s)" ring)]
            (exec [[:redraw "|" :sleep sleep_str "|" :call call_str]]))))

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

(set! pastetoggle :<F1>)

(augroup! :QFixToggle [[BufWinEnter]
                       [quickfix]
                       #(do
                          (g! qfix_win (vimfn :bufnr "$"))
                          (set! nolist)
                          (set! colorcolumn :0))]
          [[BufWinLeave]
           [quickfix]
           #(when (and (vimfn :exists (g :qfix_win))
                       (= (g :qfix_win) (vimfn :expand :<abuf>)))
              (exec [[:unlet! "g:qfix_win"]]))])

(fn ScratchBuf []
  (var scratchname :scratch)
  (var scratchbuf (vimfn :bufnr scratchname))
  (when (= -1 scratchbuf)
    (do
      (set scratchbuf (vim.api.nvim_create_buf true true))
      (vim.api.nvim_buf_set_name scratchbuf scratchname)))
  (vim.api.nvim_win_set_buf 0 scratchbuf)
  (set vim.opt_local.buftype :nofile)
  (set vim.opt_local.bufhidden :hide)
  (set vim.opt_local.swapfile false))

(command! [] :Scratch `ScratchBuf)
;; }}}

;; {{{ Visual
;; ----------
(set! showmatch)
(set! list)
(set! conceallevel 0)
(set! termguicolors)

(augroup! :ColorSchemeMods
          [[ColorScheme]
           *
           (.. "highlight SpecialKey ctermfg=red cterm=none"
               "| highlight Folded guifg=magenta gui=bold ctermbg=none ctermfg=magenta cterm=bold"
               "| highlight VertSplit guibg=none ctermbg=none guifg=#afafaf ctermfg=237"
               "| highlight Comment guifg=#df5f5f ctermfg=167 guibg=none ctermbg=none gui=none cterm=none")])

(set! listchars "tab:▕░,trail:▒,extends:>,precedes:<")

;; }}}

;; {{{ Nvim Terminal mode
;; ----------------------
(set vim.env.NVIM_LISTEN_ADDRESS vim.v.servername)
(augroup! :Terminal [[TermOpen]
                     "*"
                     (fn []
                       (set! filetype :terminal)
                       ;; Black
                       (b! terminal_color_0 "#272822")
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
                       (b! terminal_color_15 "#f9f8f5"))])

;; }}}

;; {{{ Folds
;; ---------
(set! foldcolumn :0)
(set! foldlevelstart 99)

(rem! viewoptions :options)

(augroup! :Folds
          [[FileType]
           [vim zsh lua fennel]
           (fn []
             (set vim.opt_local.foldmethod :marker)
             (set vim.opt_local.foldtext "v:lua.SimpleFoldText()"))])

(set! foldtext "v:lua.CFoldText()")

(fn PadToRight [lstring rstring]
  (let [width (vimfn :winwidth ".")
        offset (string.rep " " (- width (string.len (.. lstring rstring))))]
    (.. lstring offset rstring)))

(global SimpleFoldText (fn []
                         (let [ell " ⋯ "
                               vstart (vimfn :getline vim.v.foldstart)
                               vend (vimfn :trim
                                           (vimfn :getline vim.v.foldened))
                               startpattern "^%s*[\"#-;]+%-?%s*{{{"
                               endpattern "^%s*[\"#-;]+%-?%s*}}}"
                               vstartPrime (string.gsub vstart startpattern "")
                               vendPrime (string.gsub vend endpattern "")
                               linestring (.. " === "
                                              (table.maxn (vimfn :getline
                                                                 vim.v.foldstart
                                                                 vim.v.foldend))
                                              " lines === ")]
                           (PadToRight (.. vstartPrime " " ell " " vendPrime)
                                       linestring))))

(global CFoldText
        (fn []
          (let [ell " ⋯ "
                lines (vimfn :getline vim.v.foldstart vim.v.foldend)
                size (table.maxn lines)
                linestring (.. " === " size " lines === ")
                vstart (vimfn :getline vim.v.foldstart)]
            (if (or (string.match vstart "{$") (string.match vstart "-$"))
                (PadToRight (.. vstart ell
                                (vimfn :trim (vimfn :getline vim.v.foldend)))
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
                          (set curline (vimfn :trim curline))
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
(when (pcall require :which-key)
  (let [wk (require :which-key)]
    (wk.register {:<C-a> [:<Home> :Home]
                  :<C-e> [:<End> :End]
                  :<C-f> [:<Right> "Char Forward"]
                  :<C-b> [:<Left> "Char Back"]
                  :<Esc> {:b [:<Home> :Home] :f [:<End> :End]}
                  :w {:name :write ";" [":w<CR>" "Quick Write"]}}
                 {:nowait true :mode :c})
    (wk.register {:s {:name :Sayonara
                      ";" [:Sayonara!<CR> "Forget File Buffer"]
                      "a;" [:Sayonara!<CR> "Forget File Buffer And Layout"]}}
                 {:mode :c :silent false})
    (wk.register {:g {:k [:k "Move up one actual line"]
                      :j [:j "Move down one actual line"]
                      :0 [:0
                          "Move to the beginning of the current (actual) line"]
                      :$ ["$" "Move to the end of the current (actual) line"]
                      :f [":e <cfile><CR>" "Open file (always)"]}
                  :<leader> {:name :leader
                             :c [":set spell!<CR>" "Spell Checker"]
                             :n [":tabnext<CR>" "Next Tab"]
                             :b [":tabprev<CR>" "Prev Tab"]
                             :l {:name :LustyJuggler}}
                  :z {:name :folds
                      "[" [":set foldlevel=99<CR>" "Open all folds"]
                      "]" [":set foldlevel=0<CR>" "Close all folds"]}
                  :<C-w> {:name :+window
                          :c [":tabnew<CR>" "Create New Tab"]
                          :n [":tabnext<CR>" "Next Tab"]
                          :b [":tabprev<CR>" "Prev Tab"]}
                  :<C-f> [":TSHighlightCapturesUnderCursor<CR>"
                          "Show Highlight Group"]
                  :<F10> [":TSHighlightCapturesUnderCursor<CR>"
                          "Show Highlight Group"]
                  :<C-n> [":bnext<CR>" "Next Buffer"]
                  :<C-b> [":bprev<CR>" "Prev Buffer"]
                  :k [:gk "Move up one visual line"]
                  :j [:gj "Move down one visual line"]
                  :0 [:g0 "Move to the beginning of the current (visual) line"]
                  :$ [:g$ "Move to the end of the current (visual) line"]
                  :<C-s> [":Scratch<CR>" "Scratch Buffer"]
                  :n ["n:lua HlNext(0.4)<CR>" "Glow Next"]
                  :N ["N:lua HlNext(0.4)<CR>" "Glow Prev"]
                  ";" [":" "Quick Command"]} {:mode :n})
    (wk.register {:jk [:<Esc> "Quick Escape"]
                  :<C-n> ["pumvisible() ? \"\\<C-n>\" : \"\\<C-x>\\<C-o>\""
                          "Next Item"]
                  :<C-j> ["pumvisible() ? \"\\<C-n>\" : \"\\<C-x>\\<C-o>\""
                          "Next Item"]
                  :<C-k> [:<C-p> "Prev Item"]
                  :<S-Tab> ["pumvisible() ? \"\\<C-p> : \"\\<C-h>\""
                            "Prev Item"]} {:mode :i})
    (wk.register {:J [":m '>+1<CR>gv=gv" "Move Line Up"]
                  :K [":m '<-2<CR>gv=gv" "Move Line Down"]}
                 {:mode :v})
    (map! [t] :<C-w> "<c-\\><c-n>")))

;; }}}

;; {{{ Auto Commands
;; -----------------
; Open at last line
(augroup! :Utilities
          [[BufReadPost]
           "*"
           "if line(\"'\\\"\") > 1 && line(\"'\\\"\") <= line(\"$\") | exe \"normal! g`\\\"\" | endif"])

(augroup! :LaTeX [[FileType] [tex] "set fenc=ascii"])

(augroup! :HelpFiles [[FileType]
                      [help]
                      (.. "source " (vimfn :stdpath :config)
                          :/ftplugin/help.vim)])

(augroup! :Scala [[BufNewFile BufRead] :*.sc "set ft=scala"])
;; }}}

;; {{{ netrw
;; ---------
(g! netrw_browse_split 4)
(g! netrw_altv 1)
(g! netrw_list_hide "^\\.")
(g! netrw_hide 1)
;; }}}
(exec [[:colorscheme :janah]])

(require :neoformat_config)

