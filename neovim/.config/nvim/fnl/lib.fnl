(fn g [var_name]
  "Retrieve a global var"
  (. vim.g var_name))

(fn b [var_name]
  "Retrieve a buffer var"
  (. vim.b var_name))

(fn opt [var_name]
  "Retrieve a vim option value"
  (. (. vim.opt var_name) :_value))

(fn vimfn [func_name ...]
  "Use a vim function"
  ((. vim.fn func_name) ...))

(fn copy [xs]
  (let [res {}]
    (each [ix x (pairs xs)]
      (tset res ix x))
    res))

(fn RequireAnd [mod func]
  "Reload module cache, then call function"
  ((. (require :plenary.reload) :reload_module) mod)
  ((. (require mod) func)))

(fn Require [mod]
  "Reload module cache"
  ((. (require :plenary.reload) :reload_module) mod)
  (require mod))

{: g : b : opt : vimfn : RequireAnd : Require}

