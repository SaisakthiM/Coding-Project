-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- Add this to your lua/config/autocmds.lua or create a new file lua/config/neogit-highlights.lua

vim.api.nvim_create_autocmd("FileType", {
  pattern = "Neogit*",
  callback = function()
    -- Custom highlights for Neogit to match your theme
    vim.api.nvim_set_hl(0, "NeogitDiffAdd", { fg = "#a9dc76", bg = "#2d3139" })
    vim.api.nvim_set_hl(0, "NeogitDiffDelete", { fg = "#ff6188", bg = "#2d3139" })
    vim.api.nvim_set_hl(0, "NeogitDiffContext", { fg = "#727d8c" })
    vim.api.nvim_set_hl(0, "NeogitDiffAddHighlight", { fg = "#a9dc76", bg = "#373e47" })
    vim.api.nvim_set_hl(0, "NeogitDiffDeleteHighlight", { fg = "#ff6188", bg = "#373e47" })
    vim.api.nvim_set_hl(0, "NeogitHunkHeader", { fg = "#78dce8", bg = "#2d3139", bold = true })
    vim.api.nvim_set_hl(0, "NeogitHunkHeaderHighlight", { fg = "#78dce8", bg = "#373e47", bold = true })
    vim.api.nvim_set_hl(0, "NeogitSectionHeader", { fg = "#ffd866", bold = true })
    vim.api.nvim_set_hl(0, "NeogitChangeModified", { fg = "#ffd866" })
    vim.api.nvim_set_hl(0, "NeogitChangeAdded", { fg = "#a9dc76" })
    vim.api.nvim_set_hl(0, "NeogitChangeDeleted", { fg = "#ff6188" })
    vim.api.nvim_set_hl(0, "NeogitChangeRenamed", { fg = "#ab9df2" })
    vim.api.nvim_set_hl(0, "NeogitChangeUpdated", { fg = "#78dce8" })
    vim.api.nvim_set_hl(0, "NeogitChangeCopied", { fg = "#78dce8" })
    vim.api.nvim_set_hl(0, "NeogitBranch", { fg = "#ab9df2", bold = true })
    vim.api.nvim_set_hl(0, "NeogitRemote", { fg = "#ff6188", bold = true })
    vim.api.nvim_set_hl(0, "NeogitUnmergedInto", { fg = "#ff6188", bold = true })
    vim.api.nvim_set_hl(0, "NeogitUnpulledFrom", { fg = "#78dce8", bold = true })
    vim.api.nvim_set_hl(0, "NeogitObjectId", { fg = "#727d8c", italic = true })
    vim.api.nvim_set_hl(0, "NeogitStash", { fg = "#78dce8", italic = true })
  end,
})