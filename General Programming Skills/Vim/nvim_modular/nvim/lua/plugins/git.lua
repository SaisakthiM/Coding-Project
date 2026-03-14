return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 300,
      },
    },
  },
  {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    keys = { { "G", "<cmd>Neogit<CR>" } },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },
  { "tpope/vim-fugitive", cmd = "Git" },
}
