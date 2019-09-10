call textobj#user#plugin('sh', {
            \   'shell-var-around': {
            \     'pattern': '$[a-zA-Z_][a-zA-Z0-9_]*',
            \     'select': ['av'],
            \   },
            \   'shell-var-inside': {
            \     'pattern': '[a-zA-Z_][a-zA-Z0-9_]*',
            \     'select': ['iv'],
            \   },
            \ })
