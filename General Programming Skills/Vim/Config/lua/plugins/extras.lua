return {
  -- LazyGit for Git operations
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
      { "<leader>gf", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit Current File" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  -- Avante AI
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
  },

  -- BG.nvim for Kitty background sync
  {
    "typicode/bg.nvim",
    lazy = false,
  },

  -- Auto-save plugin
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    config = function()
      require("auto-save").setup({
        enabled = true,
        trigger_events = { "InsertLeave", "TextChanged" },
        condition = function(buf)
          local fn = vim.fn
          local utils = require("auto-save.utils")
          if
            fn.getbufvar(buf, "&modifiable") == 1 and
            utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
            return true
          end
          return false
        end,
        write_all_buffers = false,
        debounce_delay = 1000,
      })
    end,
  },

  -- ToggleTerm for terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = { { "<F12>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" } },
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<F12>]],
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = false,
        persist_size = true,
        direction = "horizontal",
      })
    end,
  },

  -- Kanagawa theme
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = false,
        undercurl = true,
        theme = "dragon",
        background = {
          dark = "dragon",
          light = "lotus",
        },
      })
      vim.cmd("colorscheme kanagawa")
      
      -- Kitty terminal integration
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "kanagawa",
        callback = function()
          if vim.o.background == "light" then
            vim.fn.system("kitty +kitten themes Kanagawa_light")
          elseif vim.o.background == "dark" then
            vim.fn.system("kitty +kitten themes Kanagawa_dragon")
          else
            vim.fn.system("kitty +kitten themes Kanagawa")
          end
        end,
      })
    end,
  },
{
  "luckasRanarison/tailwind-tools.nvim",
  name = "tailwind-tools",
  build = ":UpdateRemotePlugins",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim", -- optional
    "neovim/nvim-lspconfig", -- optional
  },
  opts = {} -- your configuration
},
 {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "tailwind-tools",
    "onsails/lspkind-nvim",
    -- ...
  },
  opts = function()
    return {
      -- ...
      formatting = {
        format = require("lspkind").cmp_format({
          before = require("tailwind-tools.cmp").lspkind_format
        }),
      },
    }
  end,
},
{
  "uga-rosa/ccc.nvim",
  config = function()
    require("ccc").setup()
  end,
}, 
{
  "norcalli/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup()
  end,
}

}
