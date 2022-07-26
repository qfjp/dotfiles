(fn g [name]
  "Retrieve a global var"
  `(. vim.g ,(tostring name)))

(fn g! [name val]
  "Set a global var"
  `(tset vim.g ,(tostring name) ,val))

(fn opt! [name val]
  `(tset (. vim.opt ,(tostring name)) :_value ,val))

(fn set! [name ?val]
  (let [name (tostring name)]
    (if (not= nil ?val)
        `(tset vim.opt ,name ,?val)
        (if (= :no (string.sub name 1 2))
            `(tset vim.opt ,(string.sub name 3) false)
            `(tset vim.opt ,name true)))))

(fn set+ [name val]
  "Appends 'val' to <name>'s option-list"
  `(: (. vim.opt ,(tostring name)) :append ,val))

(fn rem! [name val]
  `(: (. vim.opt ,(tostring name)) :remove ,val))

(fn opt [name]
  "Retrieve a vim option value"
  `(. (. vim.opt ,(tostring name) :_value)))

(fn b [name]
  "Retrieve a buffer var"
  `(. vim.b ,(tostring name)))

(fn b! [name val]
  `(tset vim.b ,(tostring name) ,val))

(fn bo [name]
  "Retrieve a buffer-scoped option"
  `(. vim.bo ,(tostring name)))

(fn vimfn [name ...]
  "Use a vim function"
  `((. vim.fn ,(tostring name)) ,...))

{: opt : b! : b : bo : g : g! : vimfn : set! : set+ : rem!}

