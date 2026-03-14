-- Custom keymaps for SAIVIM

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Terminal toggle (F12) - Simple version
keymap("n", "<F12>", function()
  require("toggleterm").toggle()
end, opts)

-- Exit terminal mode with Escape
keymap("t", "<Esc>", "<C-\\><C-n>", opts)

-- Auto cd to current file directory in terminal
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local buf_type = vim.bo.buftype
    if buf_type == "terminal" then
      local buf_dir = vim.fn.expand("%:p:h")
      if buf_dir ~= "" and vim.fn.isdirectory(buf_dir) == 1 then
        vim.cmd("startinsert!")
        local cmd = "cd " .. vim.fn.shellescape(buf_dir) .. "\n"
        local chan_id = vim.b.terminal_job_id
        if chan_id then
        end
      end
    end
  end,
})

-- Switch between file buffers with Tab
keymap("n", "<Tab>", ":bnext<CR>", opts)
keymap("n", "<S-Tab>", ":bprevious<CR>", opts)

--  Undo and Redo
-- Use Ctrl-Z for undo
keymap("n", "<C-z>", "u", { noremap = false, silent = true })
-- Use Ctrl-Y for redo
keymap("n", "<C-y>", "<C-r>", { noremap = false, silent = true })
-- Switch between tabs with Ctrl+Tab
keymap("n", "<C-Tab>", ":tabnext<CR>", opts)
keymap("n", "<C-S-Tab>", ":tabprevious<CR>", opts)

-- Window navigation with Alt+Arrows
keymap("n", "<M-Left>", ":wincmd h<CR>", opts)
keymap("n", "<M-Right>", ":wincmd l<CR>", opts)
keymap("n", "<M-Up>", ":wincmd k<CR>", opts)
keymap("n", "<M-Down>", ":wincmd j<CR>", opts)

-- Terminal mode navigation
keymap("t", "<M-Left>", "<C-\\><C-n>:wincmd h<CR>", opts)
keymap("t", "<M-Right>", "<C-\\><C-n>:wincmd l<CR>", opts)
keymap("t", "<M-Up>", "<C-\\><C-n>:wincmd k<CR>", opts)
keymap("t", "<M-Down>", "<C-\\><C-n>:wincmd j<CR>", opts)

-- Copy/Paste with system clipboard
keymap("v", "<C-c>", '"+y', opts)
keymap("n", "<C-c>", '"+yy', opts)
keymap("n", "<C-v>", '"+p', opts)
keymap("v", "<C-v>", '"+p', opts)
keymap("i", "<C-v>", "<C-r>+", opts)
keymap("t", "<C-v>", '<C-\\><C-n>"+pi', opts)

-- Buffer navigation
keymap("n", "<leader>bn", ":bnext<CR>", opts)
keymap("n", "<leader>bp", ":bprevious<CR>", opts)
keymap("n", "<leader>bd", ":bdelete<CR>", opts)
keymap("n", "<M-q>", ":bd<CR>", opts)

-- Quick save/quit
keymap("n", "<leader>w", ":w<CR>", opts)
keymap("n", "<leader>q", ":q<CR>", opts)

-- Git and Tree shortcuts (without leader key) 
keymap("n", "<M-g>", ":Neogit<CR>", opts)
keymap("n", "<M-t>", ":Neotree toggle<CR>", opts)
keymap("n", "<leader>a", ":AvanteAsk<CR>", opts)

-- Buffer navigation with Ctrl+arrows
keymap("n", "<C-Right>", ":bnext<CR>", opts)
keymap("n", "<C-Left>", ":bprevious<CR>", opts)

-- Close buffer and window
keymap("n", "<M-q>", ":bd<CR>", opts)           -- Close buffer with Alt+q
keymap("n", "<C-M-q>", ":q<CR>", opts)          -- Close window with Ctrl+Alt+q

-- Duplicate line down with Ctrl+Shift+Down
keymap("n", "<C-S-Down>", ":t.<CR>", opts)
keymap("i", "<C-S-Down>", "<Esc>:t.<CR>gi", opts)
keymap("v", "<C-S-Down>", ":t'><CR>gv", opts)

-- Duplicate line up with Ctrl+Shift+Up
keymap("n", "<C-S-Up>", ":t.-1<CR>", opts)
keymap("i", "<C-S-Up>", "<Esc>:t.-1<CR>gi", opts)
keymap("v", "<C-S-Up>", ":t'<-1<CR>gv", opts)

-- Vim-style duplication with number prefix
-- Usage: cp (duplicate current line), 5cp (duplicate 5 lines), 10cp (duplicate 10 lines)
keymap("n", "cp", function()
  local count = vim.v.count1  -- Get the count (defaults to 1)
  if count == 1 then
    -- Duplicate single line
    vim.cmd("t.")
  else
    -- Duplicate N lines (current line + N-1 lines above)
    vim.cmd(string.format(":-%d,.t.", count - 1))
  end
end, { silent = true, desc = "Duplicate line(s) - use Ncp for N lines" })

-- Visual mode: cp duplicates selected lines
keymap("v", "cp", ":t'><CR>gv", { silent = true, desc = "Duplicate selected lines" })

-- Optional: Keep leader keymaps as backup
keymap("n", "<leader>bn", ":bnext<CR>", opts)
keymap("n", "<leader>bp", ":bprevious<CR>", opts)
keymap("n", "<leader>bd", ":bdelete<CR>", opts)

-- Additional Neogit shortcuts
keymap("n", "<leader>gg", ":Neogit<CR>", opts)
keymap("n", "<leader>gc", ":Neogit commit<CR>", opts)
keymap("n", "<leader>gp", ":Neogit push<CR>", opts)
keymap("n", "<leader>gl", ":Neogit pull<CR>", opts)

-- Color Picker
vim.keymap.set("n", "<F8>", "<cmd>CccPick<CR>", { desc = "Color Picker" })
vim.keymap.set("n", "<F9>", "<cmd>CccConvert<CR>", { desc = "Color Convert" })

-- Auto-save on buffer write and focus loss
vim.api.nvim_create_autocmd("BufLeave", {
  callback = function()
    if vim.bo.modified and vim.bo.buflisted then
      vim.cmd("silent! write")
    end
  end,
})

vim.api.nvim_create_autocmd("FocusLost", {
  callback = function()
    vim.cmd("silent! wall")
  end,
})

vim.api.nvim_create_autocmd("TextChanged", {
  callback = function()
    if vim.bo.modified and vim.bo.buflisted then
      local timer = vim.loop.new_timer()
      if timer then
        timer:start(
          2000,
          0,
          vim.schedule_wrap(function()
            if vim.bo.modified then
              vim.cmd("silent! write")
            end
          end)
        )
      end
    end
  end,
})
