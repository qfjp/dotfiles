local packer_path = vim.fn.stdpath('data') .. '/site/pack/packer/start'
function Bootstrap(user, repo)
    local install_path = string.format("%s/%s", packer_path, repo)
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.fn.system(
          { 'git'
          , 'clone'
          , string.format("https://github.com/%s/%s", user, repo)
          , install_path
          })
        vim.api.nvim_command(string.format("packadd %s", repo))
        return true
    end
    return false
end

Bootstrap("udayvir-singh", "tangerine.nvim")
Bootstrap("udayvir-singh", "hibiscus.nvim")
Bootstrap('lewis6991', 'impatient.nvim')
local pack_boot = Bootstrap('wbthomason', 'packer.nvim')
local packer_table = require('plugins').packer_table
require('impatient').enable_profile()
require('packer').startup(packer_table)
if pack_boot then
    require('packer').sync()
end
require('tangerine').setup {
    target = vim.fn.stdpath [[data]] .. "/tangerine",
    rtpdirs = {
        "plugin"
    },
    compiler = {
        hooks = {"onsave", "oninit"}
    }
}
