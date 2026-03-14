-- ========================================
-- ⚙️ OPTIONS
-- ========================================

local opt = vim.opt
local g = vim.g

-- Leader
g.mapleader = " "
g.maplocalleader = " "

-- Numbers
opt.number = true
opt.relativenumber = true

-- Mouse & clipboard
opt.mouse = "a"
opt.clipboard = "unnamedplus"

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- Behavior
opt.wrap = false
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 300

-- WSL clipboard fix
if vim.fn.has("wsl") == 1 then
  g.clipboard = {
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

-- Linting enabled by default
g.lint_enabled = true

-- Load .gitignore into wildignore
local function load_gitignore()
  local gitignore = vim.fn.findfile(".gitignore", ".;")
  if gitignore ~= "" then
    for line in io.lines(gitignore) do
      if line ~= "" and not line:match("^#") then
        local pattern = line:gsub("^/", ""):gsub("%*", "*")
        opt.wildignore:append(pattern)
      end
    end
  end
end
load_gitignore()

-- ========================================
-- 🎨 FORCE CONSISTENT COLORS
-- ========================================

-- Force true color support
vim.opt.termguicolors = true

-- Force proper TERM variable
if vim.env.TERM ~= "xterm-kitty" then
  vim.env.TERM = "xterm-256color"
end

-- Force COLORTERM for true color
vim.env.COLORTERM = "truecolor"

-- Ensure complete transparency
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Main background
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })
    
    -- UI elements
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "Folded", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "NonText", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "SpecialKey", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "VertSplit", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "WinSeparator", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", ctermbg = "NONE" })
  end,
})

-- Apply immediately for current session
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })

-- Hide EndOfBuffer tildes (~)
vim.opt.fillchars = { eob = " " }
