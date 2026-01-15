return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    keys = {
      { "<leader>T", "<cmd>Neotree toggle<CR>" },
      { "T", "<cmd>Neotree toggle<CR>" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        window = {
          position = "left",
          width = 35,
        },
        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
          },
          follow_current_file = { enabled = true },
          use_libuv_file_watcher = true,
        },
        default_component_configs = {
          indent = {
            indent_size = 2,
            padding = 1,
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "",
            default = "",
          },
          git_status = {
            symbols = {
              added = "✚",
              modified = "",
              deleted = "✖",
              renamed = "󰁕",
              untracked = "",
              ignored = "",
              unstaged = "󰄱",
              staged = "",
              conflict = "",
            },
          },
        },
      })
      
      -- Kanagawa transparent theme
      vim.api.nvim_create_autocmd({"VimEnter", "ColorScheme"}, {
        callback = function()
          vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE", fg = "#c5c9c5" })
          vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "NONE", fg = "#c5c9c5" })
          vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "NeoTreeBorder", { bg = "NONE", fg = "#625e5a" })
          vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { bg = "NONE", fg = "#625e5a" })
          vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = "#8ba4b0" })
          vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = "#c4b28a" })
          vim.api.nvim_set_hl(0, "NeoTreeRootName", { fg = "#c4746e", bold = true })
          vim.api.nvim_set_hl(0, "NeoTreeFileName", { fg = "#c5c9c5" })
          vim.api.nvim_set_hl(0, "NeoTreeFileIcon", { fg = "#a292a3" })
          vim.api.nvim_set_hl(0, "NeoTreeFileNameOpened", { fg = "#8a9a7b", bold = true })
          vim.api.nvim_set_hl(0, "NeoTreeGitAdded", { fg = "#8a9a7b" })
          vim.api.nvim_set_hl(0, "NeoTreeGitDeleted", { fg = "#c4746e" })
          vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = "#c4b28a" })
          vim.api.nvim_set_hl(0, "NeoTreeGitConflict", { fg = "#E46876" })
          vim.api.nvim_set_hl(0, "NeoTreeGitUntracked", { fg = "#8ea4a2" })
          vim.api.nvim_set_hl(0, "NeoTreeGitIgnored", { fg = "#a6a69c" })
          vim.api.nvim_set_hl(0, "NeoTreeIndentMarker", { fg = "#625e5a" })
          vim.api.nvim_set_hl(0, "NeoTreeModified", { fg = "#c4b28a" })
        end,
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<leader>F", "<cmd>Telescope find_files<CR>" },
      { "<leader>R", "<cmd>Telescope oldfiles<CR>" },
      { "<leader>b", "<cmd>Telescope buffers<CR>" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        file_ignore_patterns = { "node_modules", ".git/" },
        vimgrep_arguments = {
          "rg", "--color=never", "--no-heading",
          "--with-filename", "--line-number", "--column",
          "--smart-case", "--hidden",
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
        },
      },
    },
  },
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>o", "<cmd>SymbolsOutline<CR>" } },
    opts = {
      width = 25,
      autofold_depth = 1,
    },
  },
  {
    "goolord/alpha-nvim",
    lazy = false,
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
        "           ⚡ Saivim — Kanagawa Edition",
      }
      
      dashboard.section.buttons.val = {
        dashboard.button("F", "📁 Find file", ":Telescope find_files cwd=~/Coding-Project<CR>"),
        dashboard.button("R", "🕘 Recent", ":Telescope oldfiles<CR>"),
        dashboard.button("G", "🌲 Git", ":Neogit<CR>"),
        dashboard.button("T", "🗂️  Tree", ":Neotree toggle<CR>"),
        dashboard.button("N", "📝 New", ":ene | startinsert<CR>"),
        dashboard.button("S", "💾 Session", ":lua require('persistence').load()<CR>"),
        dashboard.button("A", "🤖 AI", ":AvanteToggle<CR>"),
        dashboard.button("c", "⚙️  Config", ":e ~/.config/nvim/init.lua<CR>"),
        dashboard.button("q", "❌ Quit", ":qa<CR>"),
      }
      
      dashboard.section.footer.val = "Happy coding, Sai! 🚀"
      alpha.setup(dashboard.opts)
    end,
  },
}
