;; {{{ Startify
;; -------------
(require-macros :macros)
(local HOME (or (os.getenv :HOME) ""))
(local GIT_DIR (.. HOME :/projects/github/dotfiles))

;; Table of index/bookmark pairs.
;; The indices of the outer table are the corresponding index that the
;; bookmark will be given in startify. The inner table index is the
;; subdirectory where the file was placed for GNU stow.
(local BOOKMARK_PAIRS {:a {:neovim (.. (vim.fn.stdpath :config)
                                       :/lua/plugins.lua)}
                       :d {:neovim (.. (vim.fn.stdpath :config)
                       :f {:zsh (.. HOME :/.zshrc)}})

(local skiplist
       [:COMMIT_EDITMSG
        :.git/index
        :nvim/runtime/doc*
        (.. (vim.fn.stdpath :data) :/site/pack/packer/start/.*/doc/.*)])

(local bmark-indices (let [ixs {}]
                       (each [k _ (pairs BOOKMARK_PAIRS)]
                         (tset ixs (+ 1 (table.maxn ixs)) k))
                       ixs))

;; ensure this doesn't overlap with bmark-indices
(g! startify_custom_indices [:g :h :l :w :r :u :o :p :z :x :c :v :n :m])

;; Ensure the bookmark order is stable
(table.sort bmark-indices)

(local bookmarks {})

;; populate bookmarks, skip-list from BOOKMARK_PAIRS
(each [_ ix (ipairs bmark-indices)]
  ;; ensure the bookmark order is stable
  (let [pair (. BOOKMARK_PAIRS ix)]
    (each [dir bmark (pairs pair)]
      (let [git-path (.. GIT_DIR "/" dir (string.gsub bmark HOME ""))
            skip-len (table.maxn skiplist)
            mark-len (table.maxn bookmarks)]
        (tset bookmarks (+ mark-len 1) {ix (string.gsub bmark HOME "~")})
        (tset skiplist (+ skip-len 1) bmark)
        (tset skiplist (+ skip-len 2) git-path)))))

(vim.cmd "function! StartifyEntryFormat()
            return 'WebDevIconsGetFileTypeSymbol(absolute_path) .\" \". entry_path'
          endfunction")

(g! startify_files_number 10)
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

(fn shell [str]
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

(local cmd "~/bin/random_description.sh | cowthink -W 40 -f tux -n")

(g! startify_custom_header (center (shell (.. :MANWIDTH= 72 " " cmd)) 80))

;; }}}

