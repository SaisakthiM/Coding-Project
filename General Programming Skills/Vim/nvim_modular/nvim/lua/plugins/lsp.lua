return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls", "ts_ls", "pyright", "rust_analyzer",
        "gopls", "clangd", "html", "cssls", "jsonls",
        "yamlls", "dockerls", "bashls", "marksman",
        "jdtls", "intelephense", "kotlin_language_server",
        "omnisharp", "sqlls", "graphql", "taplo", "vimls", "cmake",
      },
      automatic_installation = true,
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = {
        "eslint_d", "stylelint", "markdownlint",
        "yamllint", "jsonlint", "hadolint",
        "golangci-lint", "phpcs", "checkstyle", "sqlfluff",
      },
      auto_update = true,
      run_on_start = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      -- Configure servers
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = { 
          Lua = { 
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          } 
        },
      })
      
      vim.lsp.config("vtsls", {
        capabilities = capabilities,
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      })
      
      vim.lsp.config("pyright", {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })
      
      vim.lsp.config("rust_analyzer", { capabilities = capabilities })
      vim.lsp.config("gopls", { capabilities = capabilities })
      vim.lsp.config("clangd", { capabilities = capabilities })
      vim.lsp.config("jdtls", {
        capabilities = capabilities,
        root_dir = vim.fs.root(0, { "gradlew", "mvnw", ".git" }),
      })
      vim.lsp.config("intelephense", { capabilities = capabilities })
      vim.lsp.config("kotlin_language_server", { capabilities = capabilities })
      vim.lsp.config("omnisharp", { capabilities = capabilities })
      vim.lsp.config("html", {
        capabilities = capabilities,
        filetypes = { "html", "javascriptreact", "typescriptreact" },
      })
      vim.lsp.config("cssls", {
        capabilities = capabilities,
        filetypes = { "css", "scss", "less", "javascriptreact", "typescriptreact" },
      })
      vim.lsp.config("tailwindcss", {
        capabilities = capabilities,
        filetypes = {
          "html", "css", "javascript", "typescript",
          "javascriptreact", "typescriptreact", "vue", "svelte"
        },
        root_dir = vim.fs.root(0, {
          "tailwind.config.js", "tailwind.config.ts",
          "postcss.config.js", "package.json", ".git",
        }),
      })
      vim.lsp.config("jsonls", { capabilities = capabilities })
      vim.lsp.config("yamlls", { capabilities = capabilities })
      vim.lsp.config("dockerls", { capabilities = capabilities })
      vim.lsp.config("bashls", { capabilities = capabilities })
      vim.lsp.config("marksman", { capabilities = capabilities })
      vim.lsp.config("sqlls", { capabilities = capabilities })
      vim.lsp.config("graphql", { capabilities = capabilities })
      vim.lsp.config("taplo", { capabilities = capabilities })
      vim.lsp.config("vimls", { capabilities = capabilities })
      vim.lsp.config("cmake", { capabilities = capabilities })
      
      -- Enable all
      vim.lsp.enable({
        "lua_ls", "vtsls", "pyright", "rust_analyzer", "gopls",
        "clangd", "jdtls", "intelephense", "kotlin_language_server",
        "omnisharp", "html", "cssls", "tailwindcss", "jsonls",
        "yamlls", "dockerls", "bashls", "marksman", "sqlls",
        "graphql", "taplo", "vimls", "cmake"
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        vue = { "eslint_d" },
        svelte = { "eslint_d" },
        python = { "ruff" },
        css = { "stylelint" },
        scss = { "stylelint" },
        less = { "stylelint" },
        markdown = { "markdownlint" },
        yaml = { "yamllint" },
        json = { "jsonlint" },
        dockerfile = { "hadolint" },
        sh = { "shellcheck" },
        c = { "clangtidy" },
        cpp = { "clangtidy" },
        go = { "golangci_lint" },
        rust = { "clippy" },
        php = { "phpcs" },
        java = { "checkstyle" },
        sql = { "sqlfluff" },
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c", "cpp", "lua", "vim", "vimdoc",
          "javascript", "typescript", "tsx",
          "python", "rust", "go",
          "html", "css", "json", "yaml",
          "bash", "markdown"
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter" },
    config = true,
  },
}
