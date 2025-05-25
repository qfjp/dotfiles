vim.g["neoformat_sql_mysqlformat"] =
    { args = { "-k", "upper", "--reindent", "--comma_first", "True", "-" }, exe = "sqlformat", stdin = 1 }

vim.g["neoformat_tex_mylatexindent"] =
    { args = { "-m", "-sl", "-g /dev/stderr", "2>/dev/null" }, exe = "latexindent", stdin = 1 }

vim.g["neoformat_scala_myscalariform"] = {
    args = {
        "-jar",
        (os.getenv("HOME") .. "/bin/scalariform-0.2.10.jar"),
        ("--preferenceFile=" .. os.getenv("HOME") .. "/.config/scalariform/scalariform.conf" .. "--stdin"),
    },
    exe = "java",
    stdin = 1,
}

vim.g["neoformat_scala_myscalafmt"] =
    { args = { "--stdin", "--config", (os.getenv("HOME") .. "/.scalafmt.conf") }, exe = "scalafmt", stdin = 1 }

vim.g["neoformat_sh_myshfmt"] = { args = { "-ln", "bash", "-i", "4", "-bn" }, exe = "shfmt" }

vim.g["neoformat_fennel_fnlfmt"] = { exe = "fnlfmt" }

vim.g["neoformat_enabled_tex"] = { "mylatexindent" }
vim.g["neoformat_enabled_sql"] = { "mysqlformat" }
vim.g["neoformat_enabled_scala"] = { "myscalariform" }
vim.g["neoformat_enabled_sh"] = { "myshfmt" }
vim.g["neoformat_enabled_zsh"] = {}
vim.g["neoformat_enabled_c"] = {}
vim.g["neoformat_enabled_haskell"] = {}
vim.g["neoformat_enabled_fennel"] = { "fnlfmt" }

vim.g["neoformat_basic_format_retab"] = 1

vim.g["neoformat_basic_format_trim"] = 1

vim.g["neoformat_run_all_formatters"] = 1

vim.api.nvim_create_augroup("Fmt", { clear = true })
return {
    vim.api.nvim_create_autocmd("BufWritePre", { command = "undojoin | Neoformat", group = "Fmt", pattern = "*fnl" }),
    vim.api.nvim_create_autocmd("BufWritePre", { command = "undojoin | Neoformat", group = "Fmt", pattern = "*py" }),
}
