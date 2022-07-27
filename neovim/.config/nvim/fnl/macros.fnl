(local M {})

(macro mod-fn [name ...]
  "Defines a function <name> and inserts it into the module table."
  `(tset M ,(tostring name) (fn ,name
                              ,...)))

(mod-fn exec [cmd-lst]
        "Execute each list of commands, sequentially. The cmd-lst should be a list of raw symbols"
        (let [result {}]
          (each [_ cmd (ipairs cmd-lst)]
            (table.insert result
                          `(vim.cmd ,(table.concat (collect [ix word (ipairs cmd)]
                                                     (values ix (tostring word)))
                                                   " "))))
          (table.insert result true)
          `(do
             ,(unpack result))))

(mod-fn g [name] "Retrieve a global var" `(. vim.g ,(tostring name)))

(mod-fn g! [name val] "Set a global var" `(tset vim.g ,(tostring name) ,val))

(mod-fn opt [name] "Retrieve a vim option value"
        `(. (. vim.opt ,(tostring name) :_value)))

(mod-fn opt! [name val]
        "Set a vim option, lua style (e.g. vim.opt.wrapscan = false)"
        `(tset (. vim.opt ,(tostring name)) :_value ,val))

(mod-fn opt-local [name] "Retrieve a vim local option value"
        `(. (. vim.opt_local ,(tostring name) :_value)))

(mod-fn opt-local! [name val]
        "Set a vim local option, lua style (e.g. vim.opt_local.wrapscan = false)"
        `(tset (. vim.opt_local ,(tostring name)) :_value ,val))

(mod-fn set! [name ?val] "Set a vim option, vim style (e.g. `set nowrapscan)"
        (let [name (tostring name)]
          (if (not= nil ?val)
              `(tset vim.opt ,name ,?val)
              (if (= :no (string.sub name 1 2))
                  `(tset vim.opt ,(string.sub name 3) false)
                  `(tset vim.opt ,name true)))))

(mod-fn setlocal! [name ?val]
        "Set a vim local option, vim style (e.g. `setlocal nowrapscan)"
        (let [name (tostring name)]
          (if (not= nil ?val)
              `(tset vim.opt_local ,name ,?val)
              (if (= :no (string.sub name 1 2))
                  `(tset vim.opt_local ,(string.sub name 3) false)
                  `(tset vim.opt_local ,name true)))))

(mod-fn set+ [name val] "Appends 'val' to <name>'s option-list"
        `(: (. vim.opt ,(tostring name)) :append ,val))

(mod-fn rem! [name val] `(: (. vim.opt ,(tostring name)) :remove ,val))

(mod-fn b [name] "Retrieve a buffer var" `(. vim.b ,(tostring name)))

(mod-fn b! [name val] `(tset vim.b ,(tostring name) ,val))

(mod-fn bo [name] "Retrieve a buffer-scoped option"
        `(. vim.bo ,(tostring name)))

(mod-fn vimfn [name ...] "Use a vim function"
        `((. vim.fn ,(tostring name)) ,...))

(mod-fn packer! [packer-tab packer-opts]
        (let [result {}
              opt-keys [:disable
                        :as
                        :installer
                        :updater
                        :after
                        :rtp
                        :opt
                        :branch
                        :tag
                        :commit
                        :lock
                        :run
                        :requires
                        :rocks
                        :config
                        :setup
                        :cmd
                        :ft
                        :keys
                        :event
                        :fn
                        :cond
                        :module
                        :module_pattern]]
          (each [plug opts (pairs packer-tab)]
            (let [this-result {1 plug}]
              (each [_ opt-key (ipairs opt-keys)]
                (tset this-result opt-key (. opts opt-key)))
              (tset result (+ 1 (length result)) `(use ,this-result))))
          `(fn [,(sym :use)]
             ,result)))

M

