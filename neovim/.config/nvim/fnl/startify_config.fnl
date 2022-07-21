;; {{{ Startify
;; -------------
(require-macros :hibiscus.vim)
(local HOME (or (os.getenv :HOME) ""))
(local GIT_DIR (.. HOME :/projects/github/dotfiles))

(local BOOKMARK_PAIRS [{:neovim (.. (vim.fn.stdpath :config) :/lua/plugins.lua)}
                       {:neovim (.. (vim.fn.stdpath :config) :/init.fnl)}
                       {:zsh (.. home :/.zshrc)}])

(local skiplist
       [:COMMIT_EDITMSG
        :.git/index
        :nvim/runtime/doc*
        (.. (vim.fn.stdpath :data) :/site/pack/packer/start/.*/doc/.*)])

(local bookmarks {})

;; populate bookmarks, skip-list from BOOKMARK_PAIRS
(each [_ pair (pairs BOOKMARK_PAIRS)]
  (let [pair (. BOOKMARK_PAIRS ix)]
    (each [dir bmark (pairs pair)]
      (let [git-path (.. GIT_DIR "/" dir (string.gsub bmark HOME ""))
            skip-len (table.maxn skiplist)
            mark-len (table.maxn bookmarks)]
        (tset bookmarks (+ mark-len 1) (string.gsub bmark home "~"))
        (tset skiplist (+ skip-len 1) bmark)
        (tset skiplist (+ skip-len 2) git-path)))))

(vim.cmd "function! StartifyEntryFormat()
            return 'WebDevIconsGetFileTypeSymbol(absolute_path) .\" \". entry_path'
          endfunction")

(g! startify_files_number 15)
(g! startify_list_order [[:MRU]
                         :files
                         [:Bookmarks]
                         :bookmarks
                         [:Sessions]
                         :sessions
                         [:Cmds]
                         :commands])

(g! startify_skiplist skiplist)
(g! startify_bookmarks bookmarks)

(fn cmd [str]
  (let [lines {}]
    (each [line (: (io.popen str) :lines)]
      (when (not= line "")
        (tset lines (+ (table.maxn lines) 1) line)))
    lines))

(fn replicate [str num]
  (let [result {}]
    (for [i 1 num]
      (tset result i str))
    (table.concat result)))

(fn center [strs cols]
  (var max 0)
  (let [centered {}]
    (each [_ str (ipairs strs)]
      (when (> (length str) max)
        (set max (length str))))
    (each [ix str (pairs strs)]
      (tset centered ix (.. (replicate " " (- (/ cols 2) (/ max 2))) str)))
    centered))

(g! startify_session_sort 1)
(g! startify_change_to_dir 0)
(g! startify_custom_indices [:a
                             :d
                             :f
                             :g
                             :h
                             :l
                             :w
                             :r
                             :u
                             :o
                             :p
                             :z
                             :x
                             :c
                             :v
                             :n
                             :m
                             "<"
                             ">"])

(g! startify_custom_header (center (cmd "~/bin/random_description.sh | cowthink -W 40 -f tux -n")
                                   80))

;; }}}

