BOOTSTRAP_PATH = vim.fn.stdpath("data") .. "/lazy"
vim.opt.rtp:prepend(BOOTSTRAP_PATH)

local function table_dup(tab)
    local result = {}
    for k, v in pairs(tab) do result[k] = v end
    return result
end

local function table_concat(tab1, tab2)
    local result = table_dup(tab1)
    for _, v in pairs(tab2) do table.insert(result, v) end
    return result
end

--- Bootstrap packages from github prior
-- to loading a package manager proper proper.
-- @param install_folder The path at which to
--        store the bootstrapped package files.
-- @param user The github user who owns the repo.
-- @param repo The github package/repository name.
-- @param[opt] clone_opts The options to pass to `git clone`.
function Bootstrap(install_folder, user, repo, setupfns, clone_opts)
    local package = string.gsub(repo, "%.nvim", "")
    local install_path = string.format("%s/%s", install_folder, repo)
    local first_run = false
    local clone_cmd = {"--depth=1"
        , string.format("https://github.com/%s/%s.git", user, repo)
        , install_path
    }
    if clone_opts then
        clone_cmd = table_concat(clone_opts, clone_cmd)
    end
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        local out = vim.fn.system(table_concat({"git", "clone"}, clone_cmd))
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
                { string.format('Failed to clone %s:\n', repo), 'ErrorMsg' },
                { out, "WarningMsg" },
                { "\nPress any key to exit..." },
            }, true, {})
            vim.fn.getchar()
            os.exit(1)
        end
        --vim.api.nvim_command(string.format("packadd %s", repo))
        first_run = true
    end
    for ix, fnPairs in ipairs(setupfns) do
        for fn, args in pairs(fnPairs) do
            if (type(fn) ~= "number") then
                require(package)[fn](args)
            elseif ix > 1 and first_run then -- specifically to run packer.sync()
                require(package)[args]()
            end
        end
    end
end

