-- Modules
local util = require("lsp-util")
local jdtls = require("jdtls")

-- Variables
local mason_path = vim.fn.expand("~/.local/share/nvim/mason")
local jdtls_install = mason_path .. "/bin/jdtls"
local root_markers = { 'gradlew', '.git', 'mvnw' }
local root_dir = require("jdtls.setup").find_root(root_markers)
local home = os.getenv("HOME")
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_folder = home .. "/.cache/jdtls/workspace" .. project_name
local path_to_mason_packages = home .. "/.local/share/nvim/mason/packages"
local path_to_jdtls = path_to_mason_packages .. "/jdtls"
local lombok_path = path_to_jdtls .. "/lombok.jar"
local path_to_jar = path_to_jdtls .. "/plugins/org.eclipse.equinox.launcher_1.6.700.v20231214-2017.jar"


-- Configuration
local config = {
  cmd = {
    "java",
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    "-javaagent:" .. lombok_path,
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-jar',
    path_to_jar,
    '-configuration', path_to_jdtls .. "/config_linux",
    '-data', workspace_folder,
  },
  settings = {
    java = {
      format = {
        enabled = true,
        settings = {
          url = vim.fn.stdpath("config") .. "/lang_servers/intellij-java-google-style.xml",
          profile = "GoogleStyle",
        }
      },
      eclipse = {
        downloadSources = true,
      },
      maven = {
        downloadSources = true,
      },
      signatureHelp = {
        enable = true
      },
      contentProvider = {
        preferred = "fernflower"
      },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*"
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
    }
  },
  capabilities = util.capabilities,
  on_attach = util.on_attach,
  root_dir = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1]),
}
jdtls.start_or_attach(config)
