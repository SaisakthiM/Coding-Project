-- ========================================
-- 🔄 AUTOCMDS
-- ========================================

local autocmd = vim.api.nvim_create_autocmd

-- Highlight yank
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Auto save
autocmd({ "TextChanged", "TextChangedI", "InsertLeave" }, {
  callback = function()
    if vim.bo.modified and vim.bo.buftype == "" then
      vim.cmd("silent! write")
    end
  end,
})

-- Start in ~/Coding-Project
autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      local dir = vim.fn.expand("~/Coding-Project")
      if vim.fn.isdirectory(dir) == 1 then
        pcall(vim.fn.chdir, dir)
      end
    end
  end,
})

-- Sync terminal directory
autocmd({ "BufEnter", "DirChanged" }, {
  callback = function()
    local file = vim.fn.expand("%:p")
    local dir  = vim.fn.expand("%:p:h")

    if file == "" or vim.fn.isdirectory(dir) ~= 1 then
      return
    end

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].buftype == "terminal" then
        local chan = vim.b[buf].terminal_job_id

        if chan and chan > 0 then
          pcall(vim.fn.chansend, chan, "cd " .. vim.fn.fnameescape(dir) .. "\n")
        end
      end
    end
  end,
})


-- Disable auto-comment
autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Auto-save session
autocmd("BufWritePre", {
  callback = function()
    require("persistence").save()
  end,
})

-- Enable colorizer
autocmd("BufEnter", {
  pattern = { "*.css", "*.scss", "*.html", "*.lua", "*.js", "*.ts", "*.jsx", "*.tsx" },
  callback = function()
    vim.cmd("ColorizerAttachToBuffer")
  end,
})

-- Lint on save/insert leave
autocmd({ "BufWritePost", "InsertLeave" }, {
  callback = function()
    if vim.g.lint_enabled then
      pcall(function()
        require("lint").try_lint()
      end)
    end
  end,
})
