return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      provider = "ollama",
      providers = {
        ollama = {
          endpoint = "http://127.0.0.1:11434",
          model = "qwen2.5-coder:3b",
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
  },
}
