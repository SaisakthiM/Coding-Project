-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Load custom SAIVIM configurations
require('config.custom-keymaps')

-- Disable swap files (simplest solution)
-- vim.opt.swapfile = false

-- Auto-save on focus lost and buffer switch
vim.api.nvim_create_autocmd({"FocusLost", "BufLeave"}, {
  pattern = "*",
  command = "silent! wa"
})

-- Auto-save every few seconds
vim.opt.updatetime = 1000  -- ms
vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
  pattern = "*",
  command = "silent! update"
})