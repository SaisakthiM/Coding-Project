-- Visual-Multi safe mappings (set BEFORE plugin loads)
vim.g.VM_maps = {
  ["Add Cursor Down"] = "<C-j>",
  ["Add Cursor Up"]   = "<C-k>",
}

return {
  { "folke/which-key.nvim", event = "VeryLazy", config = true },

  { "numToStr/Comment.nvim", keys = { "gc", "gb" }, config = true },

  { "kylechui/nvim-surround", event = "InsertEnter", config = true },

  {
    "mg979/vim-visual-multi",
    branch = "master",
    keys = { "<C-n>" }, -- ONLY this key
  },

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>" },
    },
    config = true,
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
      options = { "buffers", "curdir", "tabpages", "winsize" },
    },
  },

  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    keys = {
      { "<leader>S", '<cmd>lua require("spectre").toggle()<CR>' },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },

  {
    "akinsho/toggleterm.nvim",
    keys = {
      { "<F12>", "<cmd>ToggleTerm<CR>", mode = { "n", "t" } },
    },
    opts = {
      direction = "horizontal",
      size = 15,
      shell = "fish",
    },
  },
}
