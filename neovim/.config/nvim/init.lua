vim.opt.termguicolors = true
local packer_path = vim.fn.stdpath('data') .. '/site/pack/packer/start'
function Bootstrap(user, repo, setupfns)
    local package = string.gsub(repo, "%.nvim", "")
    local install_path = string.format("%s/%s", packer_path, repo)
    local first_run = false
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.fn.system(
          { 'git'
          , 'clone'
          , "--depth=1"
          , string.format("https://github.com/%s/%s", user, repo)
          , install_path
          })
        vim.api.nvim_command(string.format("packadd %s", repo))
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

Bootstrap("rktjmp", "hotpot.nvim", {})
Bootstrap("tsbohc","zest.nvim", {{"setup"}})
Bootstrap('lewis6991', 'impatient.nvim', {{"enable_profile"}})
Bootstrap("wbthomason", "packer.nvim", {})

if pcall(require, "hotpot") then
  require('hotpot').setup({
      provide_require_fennel = false,
      enable_hotpot_diagnostics = true,
      compiler = {
          modules = {
              correlate = true
          },
      },
      macros = {
          env = "_COMPILER"
      }
  })
  pcall(require, "startup")
end
