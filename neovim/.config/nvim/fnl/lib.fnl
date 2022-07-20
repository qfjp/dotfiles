(fn g [var_name]
  "Create a global var"
  (. vim.g var_name))

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

{: g : vimfn : RequireAnd : Require}

