(fn g [name]
  "Retrieve a global var"
  `(. vim.g ,(tostring name)))

(fn opt! [name val]
  `(tset (. vim.opt ,(tostring name)) :_value ,val))

(fn opt [name]
  "Retrieve a vim option value"
  `(. (. vim.opt ,(tostring name) :_value)))

(fn b [name]
  "Retrieve a buffer var"
  `(. vim.b ,(tostring name)))

(fn vimfn [name ...]
  "Use a vim function"
  `((. vim.fn ,(tostring name)) ,...))

{: opt : opt! : b : g : vimfn}

