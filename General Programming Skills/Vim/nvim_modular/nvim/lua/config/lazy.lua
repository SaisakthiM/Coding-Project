-- ========================================
-- 📦 LAZY SETUP
-- ========================================

require("lazy").setup("plugins", {
  defaults = { lazy = true },
  install = { colorscheme = { "kanagawa" } },
  checker = { enabled = true },

  -- ✅ THIS is the correct switch
  handlers = {
    keys = false,
  },

  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "tarPlugin", "tohtml",
        "tutor", "zipPlugin",
      },
    },
  },
})

