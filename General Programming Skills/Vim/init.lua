-- ========================================
-- Saivim init.lua (Full IDE Experience)
-- ========================================

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ========================================
-- ⚙️ USER CONFIGURATION SECTION
-- Edit these settings to customize your setup
-- ========================================

-- 🤖 AI Configuration
local AI_CONFIG = {
  enabled = true,                      -- Set to false to disable AI
  model = "qwen2.5-coder:3b",       -- Change model here
  host = "localhost",                  -- Ollama host
  port = "11434",                      -- Ollama port
  display_mode = "split",              -- "split" or "float"
}

-- 📁 Directory Configuration
local DIR_CONFIG = {
  coding_project = "~/Coding-Project", -- Your main coding directory
  auto_cd_on_start = true,            -- Auto change to coding_project on start
  sync_terminal_dir = true,           -- Auto sync terminal with file directory
}

-- 🖥️ Terminal Configuration
local TERMINAL_CONFIG = {
  shell = "fish",                     -- Your shell: "fish", "bash", "zsh"
  direction = "horizontal",           -- "horizontal" (bottom) or "vertical" (right)
  size = 15,                          -- Lines for horizontal, % for vertical
  toggle_key = "<F12>",              -- Key to toggle terminal
}

-- 🌲 File Tree Configuration
local TREE_CONFIG = {
  width = 35,                         -- Width of file tree
  show_hidden = true,                 -- Show hidden files
  auto_close = true,                  -- Close if last window
}

-- 🎨 Theme Configuration
local THEME_CONFIG = {
  theme = "kanagawa",                 -- Theme name
  variant = "wave",                   -- "wave", "dragon", "lotus"
  transparent = true,                 -- Transparent background
}

-- ⌨️ Keyboard Navigation
local NAV_CONFIG = {
  use_ctrl_arrows = true,             -- Use Ctrl+Arrows for window nav
  use_ctrl_hjkl = false,              -- Also enable Ctrl+hjkl (set to true if you want both)
}

-- ========================================
-- END OF USER CONFIGURATION
-- ========================================

-- ========================================
-- Plugins
-- ========================================

require("lazy").setup({
  -- Theme
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        transparent = THEME_CONFIG.transparent,
        theme = THEME_CONFIG.variant,
        overrides = function(colors)
          local theme = colors.theme
          return {
            -- Sync with Kitty terminal colors
            Normal = { bg = "NONE" },
            NormalNC = { bg = "NONE" },
            
            -- Avante sidebar - use terminal background
            NormalFloat = { bg = "NONE" },
            FloatBorder = { fg = "NONE", bg = "NONE" },
            FloatTitle = { fg = theme.syn.fun, bg = "NONE", bold = true },
            WinSeparator = { fg = "NONE", bg = "NONE" },
            VertSplit = { fg = "NONE", bg = "NONE" },
            
            -- Additional Avante border removal
            AvanteWinBar = { fg = theme.syn.fun, bg = "NONE" },
            AvanteWinBarNC = { fg = theme.ui.fg_dim, bg = "NONE" },
            AvanteSeparator = { fg = "NONE", bg = "NONE" },
            
            -- Avante specific highlights
            AvanteTitle = { fg = theme.syn.fun, bg = "NONE", bold = true },
            AvanteReversedTitle = { fg = theme.ui.bg, bg = theme.syn.fun },
            AvanteSubtitle = { fg = theme.syn.identifier, bg = "NONE" },
            AvanteReversedSubtitle = { fg = theme.ui.bg, bg = theme.syn.identifier },
            AvanteThirdTitle = { fg = theme.syn.string, bg = "NONE" },
            AvanteReversedThirdTitle = { fg = theme.ui.bg, bg = theme.syn.string },
            
            -- Avante content areas
            AvanteConflictCurrent = { bg = theme.diff.change },
            AvanteConflictIncoming = { bg = theme.diff.add },
            AvanteConflictCurrentLabel = { fg = theme.ui.bg, bg = theme.diag.warning },
            AvanteConflictIncomingLabel = { fg = theme.ui.bg, bg = theme.diag.hint },
            
            -- Popup menus
            Pmenu = { fg = theme.ui.fg, bg = "NONE" },
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
            
            -- Diff colors
            DiffAdd = { fg = "NONE", bg = theme.diff.add },
            DiffDelete = { fg = "NONE", bg = theme.diff.delete },
            DiffChange = { fg = "NONE", bg = theme.diff.change },
            DiffText = { fg = "NONE", bg = theme.diff.text },
          }
        end,
      })
      vim.cmd.colorscheme(THEME_CONFIG.theme .. "-" .. THEME_CONFIG.variant)
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local coding_project = vim.fn.expand("~/Coding-Project")
      
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { 
            "node_modules", 
            ".git/",
            "%.jpg",
            "%.jpeg",
            "%.png",
            "%.svg",
            "%.otf",
            "%.ttf",
            "%.lock",
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
          },
        },
      })
    end,
  },

  -- Alpha dashboard
  {
    "goolord/alpha-nvim",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      
      dashboard.section.header.val = {
        "███████╗ █████╗ ██╗██╗   ██╗██╗███╗   ███╗",
        "██╔════╝██╔══██╗██║██║   ██║██║████╗ ████║",
        "███████╗███████║██║██║   ██║██║██╔████╔██║",
        "╚════██║██╔══██║██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "███████║██║  ██║██║ ╚████╔╝ ██║██║ ╚═╝ ██║",
        "╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
        "⚡ Saivim — Full IDE Experience",
      }
      
      dashboard.section.buttons.val = {
        dashboard.button("F", "📁 Find file", ":lua require('telescope.builtin').find_files({ cwd = vim.fn.expand('" .. DIR_CONFIG.coding_project .. "') })<CR>"),
        dashboard.button("R", "🕘 Recent files", ":Telescope oldfiles<CR>"),
	dashboard.button("G", "🌲 Git tree", ":Neogit<CR>"),
        dashboard.button("T", "🗂️ File tree", ":Neotree toggle<CR>"),
        dashboard.button("N", "📝 New file", ":ene | startinsert<CR>"),
        dashboard.button("S", "💾 Restore session", ":lua require('persistence').load()<CR>"),
        dashboard.button("A", "🤖 AI Chat", ":AvanteToggle<CR>"),
        dashboard.button("c", "⚙️  Config", ":edit ~/.config/nvim/init.lua<CR>"),
        dashboard.button("q", "❌ Quit", ":qa<CR>"),
      }
      
      dashboard.section.footer.val = "Happy coding, Sai!"
      alpha.setup(dashboard.opts)
    end,
  },

  -- ToggleTerm (Fish terminal at bottom, full width)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        direction = TERMINAL_CONFIG.direction,
        size = TERMINAL_CONFIG.size,
        shell = TERMINAL_CONFIG.shell,
      })
      
      local Terminal = require("toggleterm.terminal").Terminal
      local fish = Terminal:new({
        direction = TERMINAL_CONFIG.direction,
        hidden = true,
      })
      
      function _FISH_TOGGLE()
        fish:toggle()
      end
      
      vim.keymap.set("n", TERMINAL_CONFIG.toggle_key, _FISH_TOGGLE, { silent = true, desc = "Toggle terminal" })
      vim.keymap.set("t", TERMINAL_CONFIG.toggle_key, _FISH_TOGGLE, { silent = true, desc = "Toggle terminal" })
    end,
  },

  -- LSP + Mason
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = true
  },
  
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "pyright",
          "rust_analyzer",
          "gopls",
          "clangd",
          "html",
          "cssls",
          "jsonls",
          "ruff",  -- Python linter/formatter
        },
        automatic_installation = true,
      })
    end,
  },
  
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      -- Lua
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } }
          }
        }
      })
      
      -- TypeScript/JavaScript
      vim.lsp.config("ts_ls", { capabilities = capabilities })
      
      -- Python
      vim.lsp.config("pyright", {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            }
          }
        }
      })
      
      -- Rust
      vim.lsp.config("rust_analyzer", { capabilities = capabilities })
      
      -- Go
      vim.lsp.config("gopls", { capabilities = capabilities })
      
      -- C/C++
      vim.lsp.config("clangd", { capabilities = capabilities })
      
      -- HTML
      vim.lsp.config("html", { capabilities = capabilities })
      
      -- CSS
      vim.lsp.config("cssls", { capabilities = capabilities })
      
      -- JSON
      vim.lsp.config("jsonls", { capabilities = capabilities })
      
      -- Enable LSP servers
      vim.lsp.enable({ "lua_ls", "ts_ls", "pyright", "rust_analyzer", "gopls", "clangd", "html", "cssls", "jsonls" })
    end,
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "black", "isort" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          json = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          markdown = { "prettier" },
          rust = { "rustfmt" },
          go = { "gofmt" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      
      -- Only enable linters that are actually installed
      lint.linters_by_ft = {
        python = { "ruff" },  -- ruff is faster and comes with many Python tools
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
      }
      
      -- Auto-lint on save and when entering insert mode
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          -- Only lint if linter is available
          pcall(function()
            require("lint").try_lint()
          end)
        end,
      })
    end,
  },

  -- Completion
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "rafamadriz/friendly-snippets" },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
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
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      npairs.setup({
        check_ts = true,
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
        },
      })
      
      -- Integration with cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = { char = "│" },
        scope = { enabled = true },
      })
    end,
  },

  -- Trouble (Better diagnostics)
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({})
    end,
  },

  -- Noice (Better UI)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
      })
    end,
  },

  -- Notify
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#000000",
        render = "minimal",
      })
      vim.notify = require("notify")
    end,
  },

  -- Symbols Outline
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require("symbols-outline").setup({
        width = 25,
        autofold_depth = 1,
      })
    end,
  },

  -- Multi-cursor
  {
    "mg979/vim-visual-multi",
    branch = "master",
  },

  -- Session Management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
      require("persistence").setup({
        dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
      })
    end,
  },

  -- Git blame inline
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",
          delay = 300,
        },
      })
    end,
  },
  
  { "tpope/vim-fugitive" },

  -- Color highlighter
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        "*",
      }, {
        RGB = true,
        RRGGBB = true,
        names = true,
        RRGGBBAA = true,
        css = true,
        css_fn = true,
      })
    end,
  },

  -- File Explorer (Neo-tree - Better alternative)
{
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x", -- stable branch
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- optional, for file icons
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        filtered_items = {
          visible = true, -- show hidden files
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
    })
    -- Toggle Neo-tree with G
    vim.keymap.set("n", "T", ":Neotree toggle<CR>", { noremap = true, silent = true })
  end,
},

  
{
  "TimUntersberger/neogit",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("neogit").setup({})
    vim.keymap.set("n", "G", ":Neogit<CR>", { noremap = true, silent = true })
  end,
},

  -- Statusline + Tabline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "kanagawa",
        },
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "left",
            },
          },
        },
      })
    end,
  },

  -- Utilities
  { "folke/which-key.nvim", config = true },
  { "numToStr/Comment.nvim", config = true },
  { "kylechui/nvim-surround", config = true },

  -- AI Assistant (Ollama integration)
  AI_CONFIG.enabled and {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      provider = "ollama",
      providers = {
        ollama = {
          endpoint = "http://127.0.0.1:11434",
          model = AI_CONFIG.model,
          timeout = 30000,
          temperature = 0,
          max_tokens = 4096,
        },
      },
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = true,
      },
      mappings = {
        ask = "<leader>aa",
        edit = "<leader>ae",
        refresh = "<leader>ar",
        submit = { normal = "<CR>", insert = "<C-s>" },
      },
      hints = { enabled = true },
      windows = {
        position = "right",
        wrap = true,
        width = 35,
        sidebar_header = {
          align = "center",
          rounded = false,
        },
      },
      highlights = {
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
        sidebar = {
          background = "NormalFloat",
          header = "Title",
        },
      },
      diff = { autojump = true, list_opener = "copen" },
    },
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
  } or nil,

  -- Project-wide search (Spectre)
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("spectre").setup()
    end,
  },
})

-- ========================================
-- General Options
-- ========================================

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"  -- Use system clipboard
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Fix clipboard for WSL/Linux
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

-- ========================================
-- Keymaps
-- ========================================

local map = vim.keymap.set

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Telescope shortcuts
map("n", "<leader>F", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true, desc = "Find file" })
map("n", "<leader>R", "<cmd>Telescope oldfiles<CR>", { noremap = true, silent = true, desc = "Recent files" })
map("n", "<leader>b", "<cmd>Telescope buffers<CR>", { noremap = true, silent = true, desc = "Buffers" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true, desc = "Live grep" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { noremap = true, silent = true, desc = "Help tags" })

-- Git status with proper error handling
map("n", "<leader>G", function()
  -- Check if we're in a git repository
  local handle = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null")
  local result = handle:read("*a")
  handle:close()
  
  if result:match("true") then
    vim.cmd("Telescope git_status")
  else
    vim.notify("Not in a git repository. Open a project with git first.", vim.log.levels.WARN)
  end
end, { noremap = true, silent = true, desc = "Git status" })

-- Alternative: Neo-tree git view
map("n", "<leader>gg", "<cmd>Neotree git_status<CR>", { noremap = true, silent = true, desc = "Git status (Neo-tree)" })

-- File tree
map("n", "<leader>T", "<cmd>Neotree toggle<CR>", { noremap = true, silent = true, desc = "File tree" })
map("n", "<leader>e", "<cmd>Neotree focus<CR>", { noremap = true, silent = true, desc = "Focus file tree" })

-- New file
map("n", "<leader>N", "<cmd>ene | startinsert<CR>", { noremap = true, silent = true, desc = "New file" })

-- LSP keymaps
map("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true, desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { noremap = true, silent = true, desc = "Go to declaration" })
map("n", "gr", vim.lsp.buf.references, { noremap = true, silent = true, desc = "References" })
map("n", "gi", vim.lsp.buf.implementation, { noremap = true, silent = true, desc = "Go to implementation" })
map("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true, desc = "Hover documentation" })
map("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true, desc = "Rename" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true, desc = "Code action" })
map("n", "<leader>f", function() require("conform").format({ lsp_fallback = true }) end, { desc = "Format buffer" })

-- Trouble
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer Diagnostics (Trouble)" })
map("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>", { desc = "Location List (Trouble)" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { desc = "Quickfix List (Trouble)" })

-- Symbols Outline
map("n", "<leader>o", "<cmd>SymbolsOutline<CR>", { noremap = true, silent = true, desc = "Symbols outline" })

-- Session management
map("n", "<leader>ss", function() require("persistence").load() end, { desc = "Restore Session" })
map("n", "<leader>sl", function() require("persistence").load({ last = true }) end, { desc = "Restore Last Session" })
map("n", "<leader>sd", function() require("persistence").stop() end, { desc = "Don't Save Current Session" })

-- Project-wide search and replace
map("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
map("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', { desc = "Search current word" })

-- AI Assistant (Ollama) - Only add shortcuts if AI is enabled
if AI_CONFIG.enabled then
  map("n", "<leader>ai", "<cmd>AvanteAsk<CR>", { desc = "Open AI assistant" })
  map("v", "<leader>ai", "<cmd>AvanteAsk<CR>", { desc = "AI on selection" })
  map("n", "<leader>ac", "<cmd>AvanteChat<CR>", { desc = "AI Chat" })
  map("v", "<leader>ac", "<cmd>AvanteChat<CR>", { desc = "AI Chat with selection" })

  -- AI quick actions
  map("n", "<leader>ae", "<cmd>AvanteEdit<CR>", { desc = "AI: Edit code" })
  map("v", "<leader>ae", "<cmd>AvanteEdit<CR>", { desc = "AI: Edit code" })
  map("n", "<leader>ar", "<cmd>AvanteRefresh<CR>", { desc = "AI: Refresh" })
  map("n", "<leader>at", "<cmd>AvanteToggle<CR>", { desc = "AI: Toggle sidebar" })

  -- Switch AI models easily
  map("n", "<leader>am", function()
    vim.ui.input({ prompt = "Enter model name: ", default = AI_CONFIG.model }, function(input)
      if input then
        -- Update Avante config
        require("avante.config").override({ 
          providers = { 
            ollama = { model = input } 
          } 
        })
        vim.notify("AI model changed to: " .. input, vim.log.levels.INFO)
      end
    end)
  end, { desc = "Change AI model" })
end

-- Buffer navigation
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Window navigation (easily switch between tree, file, terminal)
map("n", "<C-Left>", "<C-w>h", { desc = "Go to left window (tree)" })
map("n", "<C-Down>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-Up>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-Right>", "<C-w>l", { desc = "Go to right window (terminal/file)" })

-- Terminal mode navigation (so you can switch FROM terminal easily)
map("t", "<C-Left>", "<C-\\><C-n><C-w>h", { desc = "Go to left window from terminal" })
map("t", "<C-Down>", "<C-\\><C-n><C-w>j", { desc = "Go to lower window from terminal" })
map("t", "<C-Up>", "<C-\\><C-n><C-w>k", { desc = "Go to upper window from terminal" })
map("t", "<C-Right>", "<C-\\><C-n><C-w>l", { desc = "Go to right window from terminal" })

-- Quick terminal escape (easier than Ctrl+\ Ctrl+n)
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Better indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Quality of life shortcuts
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa<CR>", { desc = "Quit all" })
map("n", "<leader>x", "<cmd>wq<CR>", { desc = "Save and quit" })
map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Copy/Paste shortcuts (additional to system clipboard)
map("v", "<C-c>", '"+y', { desc = "Copy to clipboard" })
map("n", "<C-v>", '"+p', { desc = "Paste from clipboard" })
map("i", "<C-v>", '<C-r>+', { desc = "Paste from clipboard in insert mode" })
map("v", "<C-x>", '"+d', { desc = "Cut to clipboard" })

-- Select all
map("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Move lines
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- ========================================
-- Completion
-- ========================================

local cmp = require("cmp")
local luasnip = require("luasnip")

-- Load friendly snippets
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
    { name = "path" },
  }),
})

-- ========================================
-- Auto Commands
-- ========================================

-- Start in coding directory (if enabled)
if DIR_CONFIG.auto_cd_on_start then
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      if vim.fn.argc() == 0 then
        local coding_project = vim.fn.expand(DIR_CONFIG.coding_project)
        if vim.fn.isdirectory(coding_project) == 1 then
          local success, err = pcall(vim.fn.chdir, coding_project)
          if not success then
            vim.notify("Could not change to " .. DIR_CONFIG.coding_project .. ": " .. tostring(err), vim.log.levels.WARN)
          end
        end
      end
    end,
  })
end

-- Auto-change terminal directory to match current file (if enabled)
if DIR_CONFIG.sync_terminal_dir then
  vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
    callback = function()
      local current_file = vim.fn.expand("%:p")
      local current_dir = vim.fn.expand("%:p:h")
      
      if current_file ~= "" and vim.fn.isdirectory(current_dir) == 1 then
        local term_buffers = vim.tbl_filter(function(buf)
          return vim.bo[buf].buftype == "terminal"
        end, vim.api.nvim_list_bufs())
        
        for _, buf in ipairs(term_buffers) do
          local chan = vim.bo[buf].channel
          if chan then
            vim.fn.chansend(chan, string.format("cd '%s'\n", current_dir))
          end
        end
      end
    end,
  })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Auto-save session
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  callback = function()
    require("persistence").save()
  end,
})

-- Disable auto-comment on new line
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Enable colorizer for specific file types
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.css", "*.scss", "*.html", "*.lua", "*.js", "*.ts", "*.jsx", "*.tsx" },
  callback = function()
    vim.cmd("ColorizerAttachToBuffer")
  end,
})