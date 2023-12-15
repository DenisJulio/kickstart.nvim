local util = require("util")

local mason_path = vim.fn.expand("~/.local/share/nvim/mason")
local jdtls_install = mason_path .. "/bin/jdtls"
-- print(jdtls_install)
local config = {
    cmd = { jdtls_install },
    capabilities = util.capabilities,
    on_attach = util.on_attach,
    root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
}
require('jdtls').start_or_attach(config)
