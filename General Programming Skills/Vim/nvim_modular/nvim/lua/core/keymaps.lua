-- ========================================
-- ⌨️ KEYMAPS
-- ========================================

local map = vim.keymap.set


-- File Navigation
map("n", "<leader>F", "<cmd>Telescope find_files<CR>", { desc = "Find file" })
map("n", "<leader>R", "<cmd>Telescope oldfiles<CR>", { desc = "Recent" })
map("n", "<leader>b", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Grep" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help" })

-- File Tree
map("n", "<leader>T", "<cmd>Neotree toggle<CR>", { desc = "Toggle tree" })
map("n", "T", "<cmd>Neotree toggle<CR>", { desc = "Toggle tree" })
map("n", "<leader>e", "<cmd>Neotree focus<CR>", { desc = "Focus tree" })

-- New File
map("n", "<leader>N", "<cmd>ene | startinsert<CR>", { desc = "New file" })

-- Git
map("n", "G", "<cmd>Neogit<CR>", { desc = "Git UI" })
map("n", "<leader>G", function()
  local handle = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null")
  local result = handle:read("*a")
  handle:close()
  if result:match("true") then
    vim.cmd("Telescope git_status")
  else
    vim.notify("Not in a git repository", vim.log.levels.WARN)
  end
end, { desc = "Git status" })
map("n", "<leader>gg", "<cmd>Neotree git_status<CR>", { desc = "Git status tree" })

-- LSP
map("n", "gd", vim.lsp.buf.definition, { desc = "Definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Declaration" })
map("n", "gr", vim.lsp.buf.references, { desc = "References" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

-- Diagnostics
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics" })
map("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>", { desc = "Location list" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { desc = "Quickfix" })

-- Symbols
map("n", "<leader>o", "<cmd>SymbolsOutline<CR>", { desc = "Outline" })

-- AI (Avante)
map("n", "<leader>ai", "<cmd>AvanteAsk<CR>", { desc = "AI ask" })
map("v", "<leader>ai", "<cmd>AvanteAsk<CR>", { desc = "AI ask" })
map("n", "<leader>ac", "<cmd>AvanteChat<CR>", { desc = "AI chat" })
map("v", "<leader>ac", "<cmd>AvanteChat<CR>", { desc = "AI chat" })
map("n", "<leader>ae", "<cmd>AvanteEdit<CR>", { desc = "AI edit" })
map("v", "<leader>ae", "<cmd>AvanteEdit<CR>", { desc = "AI edit" })
map("n", "<leader>ar", "<cmd>AvanteRefresh<CR>", { desc = "AI refresh" })
map("n", "<leader>at", "<cmd>AvanteToggle<CR>", { desc = "AI toggle" })
map("n", "<leader>am", function()
  vim.ui.input({ prompt = "Model: ", default = "qwen2.5-coder:3b" }, function(input)
    if input then
      require("avante.config").override({ 
        providers = { ollama = { model = input } } 
      })
      vim.notify("Model: " .. input, vim.log.levels.INFO)
    end
  end)
end, { desc = "Change AI model" })

-- Session
map("n", "<leader>ss", function() require("persistence").load() end, { desc = "Restore" })
map("n", "<leader>sl", function() require("persistence").load({ last = true }) end, { desc = "Last" })
map("n", "<leader>sd", function() require("persistence").stop() end, { desc = "Don't save" })

-- Search & Replace
map("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', { desc = "Spectre" })
map("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', { desc = "Search word" })

-- Buffers
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete" })

-- Tabs
map("n", "<S-Right>", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<S-Left>", "<cmd>tabprevious<CR>", { desc = "Prev tab" })
map("n", "<C-t>", "<cmd>tab split<CR>", { desc = "New tab" })

-- Windows

-- Normal mode window navigation
map("n", "<M-Left>",  "<C-w>h", { desc = "Left" })
map("n", "<M-Down>",  "<C-w>j", { desc = "Down" })
map("n", "<M-Up>",    "<C-w>k", { desc = "Up" })
map("n", "<M-Right>", "<C-w>l", { desc = "Right" })

-- Terminal mode window navigation
map("t", "<M-Left>",  "<C-\\><C-n><C-w>h", { desc = "Left" })
map("t", "<M-Down>",  "<C-\\><C-n><C-w>j", { desc = "Down" })
map("t", "<M-Up>",    "<C-\\><C-n><C-w>k", { desc = "Up" })
map("t", "<M-Right>", "<C-\\><C-n><C-w>l", { desc = "Right" })

-- Exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>")



-- Editing
map("n", "<C-z>", "u", { desc = "Undo" })
map("n", "<C-y>", "<C-r>", { desc = "Redo" })
map("v", "<", "<gv")
map("v", ">", ">gv")
map("n", "<A-j>", "<cmd>m .+1<CR>==")
map("n", "<A-k>", "<cmd>m .-2<CR>==")
map("v", "<A-j>", ":m '>+1<CR>gv=gv")
map("v", "<A-k>", ":m '<-2<CR>gv=gv")

-- Clipboard
map("v", "<C-c>", '"+y')
map("n", "<C-v>", '"+p')
map("i", "<C-v>", '<C-r>+')
map("v", "<C-x>", '"+d')
map("n", "<C-a>", "ggVG")

-- QOL
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa<CR>", { desc = "Quit all" })
map("n", "<leader>x", "<cmd>wq<CR>", { desc = "Save & quit" })
map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "No highlight" })

-- Toggle lint
map("n", "<leader>lt", function()
  vim.g.lint_enabled = not vim.g.lint_enabled
  print("Linting " .. (vim.g.lint_enabled and "enabled" or "disabled"))
end, { desc = "Toggle lint" })
