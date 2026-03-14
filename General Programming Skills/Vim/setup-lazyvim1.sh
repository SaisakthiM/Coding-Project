#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   SAIVIM - LazyVim Setup${NC}"
echo -e "${BLUE}========================================${NC}\n"

NVIM_CONFIG_DIR="$HOME/.config/nvim"
BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%s)"

# Step 1: Install dependencies
echo -e "${YELLOW}[1/5] Installing dependencies...${NC}"
if command -v apt &> /dev/null; then
    sudo apt update
    sudo apt install -y neovim git curl xclip ripgrep fd-find
elif command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm neovim git curl xclip ripgrep fd
elif command -v dnf &> /dev/null; then
    sudo dnf install -y neovim git curl xclip ripgrep fd
fi

# Step 2: Backup existing config
if [ -d "$NVIM_CONFIG_DIR" ]; then
    echo -e "${YELLOW}[2/5] Backing up existing config to $BACKUP_DIR${NC}"
    cp -r "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
else
    mkdir -p "$NVIM_CONFIG_DIR"
fi

# Step 3: Clone LazyVim starter
echo -e "${YELLOW}[3/5] Cloning LazyVim starter...${NC}"
rm -rf "$NVIM_CONFIG_DIR"
git clone https://github.com/LazyVim/starter "$NVIM_CONFIG_DIR"
cd "$NVIM_CONFIG_DIR"

# Step 3.5: Install LSP servers immediately
echo -e "${YELLOW}[3.5/5] Installing LSP servers and build tools...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}[!] Node.js not found, some servers may not install${NC}"
fi

if ! command -v pip &> /dev/null && ! command -v pip3 &> /dev/null; then
    echo -e "${YELLOW}[!] Python pip not found, some servers may not install${NC}"
fi

# Step 4: Create custom plugin files
echo -e "${YELLOW}[4/5] Adding custom configurations...${NC}"

# Create lua/config/keymaps.lua
mkdir -p lua/config

cat > lua/config/custom-keymaps.lua << 'KEYMAPSEOF'
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
          vim.fn.chansend(chan_id, cmd)
        end
      end
    end
  end,
})

-- Switch between file buffers with Tab
keymap("n", "<Tab>", ":bnext<CR>", opts)
keymap("n", "<S-Tab>", ":bprevious<CR>", opts)

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
keymap("t", "<C-v>", "<C-\\><C-n>\"+pi", opts)

-- Buffer navigation
keymap("n", "<leader>bn", ":bnext<CR>", opts)
keymap("n", "<leader>bp", ":bprevious<CR>", opts)
keymap("n", "<leader>bd", ":bdelete<CR>", opts)

-- Quick save/quit
keymap("n", "<leader>w", ":w<CR>", opts)
keymap("n", "<leader>q", ":q<CR>", opts)

-- Git and Tree shortcuts (without leader key) - using Ctrl for less conflicts
keymap("n", "<C-g>", ":LazyGit<CR>", opts)
keymap("n", "<C-t>", function() require("snacks").explorer() end, { silent = true })
keymap("n", "<leader>a", ":AvanteAsk<CR>", opts)

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
        timer:start(2000, 0, vim.schedule_wrap(function()
          if vim.bo.modified then
            vim.cmd("silent! write")
          end
        end))
      end
    end
  end,
})
KEYMAPSEOF

# Create lua/plugins/snacks-dashboard.lua
mkdir -p lua/plugins

cat > lua/plugins/snacks-dashboard.lua << 'SNACKSEOF'
return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        git_status = true,
        git_status_open = true,
        git_untracked = true,
        watch = true,
        diagnostics = true,
      },
      dashboard = {
        enabled = true,
        width = 100,
        row = nil,
        col = nil,
        preset = {
          header = [[
  ███████╗ █████╗ ██╗██╗   ██╗██╗███╗   ███╗
  ██╔════╝██╔══██╗██║██║   ██║██║████╗ ████║
  ███████╗███████║██║██║   ██║██║██╔████╔██║
  ╚════██║██╔══██║██║╚██╗ ██╔╝██║██║╚██╔╝██║
  ███████║██║  ██║██║ ╚████╔╝ ██║██║ ╚═╝ ██║
  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
          ]],
        },
        sections = {
          { section = "header" },
          {
            pane = 1,
            section = "keys",
            gap = 1,
            padding = 1,
          },
          {
            pane = 1,
            icon = " ",
            title = "Quick Actions",
            padding = 1,
            indent = 2,
            items = {
              { icon = "  ", key = "g", desc = "Git (LazyGit)", action = "LazyGit" },
              { icon = "  ", key = "t", desc = "File Tree", action = "Snacks.explorer" },
              { icon = "  ", key = "a", desc = "Avante AI", action = "AvanteAsk" },
            },
          },
          {
            pane = 2,
            section = "recent_files",
            title = "Recent Files",
            limit = 8,
            indent = 2,
            padding = 1,
          },
          {
            pane = 2,
            icon = " ",
            title = "Projects",
            section = "projects",
            limit = 3,
            indent = 2,
            padding = 1,
          },
          {
            section = "startup",
          },
        },
      },
    },
  },
}
SNACKSEOF

# Create lua/plugins/extras.lua
cat > lua/plugins/extras.lua << 'EXTRASEOF'
return {
  -- LazyGit for Git operations
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
      { "<leader>gf", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit Current File" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  -- Avante AI
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
  },

  -- BG.nvim for Kitty background sync
  {
    "typicode/bg.nvim",
    lazy = false,
  },

  -- Auto-save plugin
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    config = function()
      require("auto-save").setup({
        enabled = true,
        trigger_events = { "InsertLeave", "TextChanged" },
        condition = function(buf)
          local fn = vim.fn
          local utils = require("auto-save.utils")
          if
            fn.getbufvar(buf, "&modifiable") == 1 and
            utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
            return true
          end
          return false
        end,
        write_all_buffers = false,
        debounce_delay = 1000,
      })
    end,
  },

  -- ToggleTerm for terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = { { "<F12>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" } },
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<F12>]],
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = false,
        persist_size = true,
        direction = "horizontal",
      })
    end,
  },

  -- Kanagawa theme
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = false,
        undercurl = true,
        theme = "dragon",
        background = {
          dark = "dragon",
          light = "lotus",
        },
      })
      vim.cmd("colorscheme kanagawa")
      
      -- Kitty terminal integration
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "kanagawa",
        callback = function()
          if vim.o.background == "light" then
            vim.fn.system("kitty +kitten themes Kanagawa_light")
          elseif vim.o.background == "dark" then
            vim.fn.system("kitty +kitten themes Kanagawa_dragon")
          else
            vim.fn.system("kitty +kitten themes Kanagawa")
          end
        end,
      })
    end,
  },
}
EXTRASEOF

# Step 5: Add to init.lua
echo -e "${YELLOW}[5/5] Configuring init.lua...${NC}"

# Append custom keymaps loading to init.lua
echo "" >> "$NVIM_CONFIG_DIR/init.lua"
echo "-- Load custom SAIVIM configurations" >> "$NVIM_CONFIG_DIR/init.lua"
echo "require('config.custom-keymaps')" >> "$NVIM_CONFIG_DIR/init.lua"

# Step 5.5: Install LSP servers using headless Neovim
echo -e "${YELLOW}[5.5/5] Installing LSP servers (this will take 2-5 minutes)...${NC}"
nvim --headless -c "MasonInstall typescript-language-server html-lsp css-lsp tailwindcss-language-server pyright bash-language-server lua-language-server clangd gopls rust-analyzer ruby-lsp jdtls json-lsp yaml-language-server terraform-ls marksman vue-language-server intelephense kotlin-language-server dockerfile-language-server graphql-language-service-cli" -c "qa" 2>/dev/null || true

echo -e "${GREEN}[✓] LSP servers installation started${NC}"

# Step 6: Done!
echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}   ✓ SAIVIM Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}\n"

echo -e "${BLUE}Features Installed:${NC}"
echo -e "  ✓ LazyVim framework"
echo -e "  ✓ SAIVIM Dashboard with custom header (Snacks)"
echo -e "  ✓ Git (LazyGit), Explorer (Snacks), Avante AI"
echo -e "  ✓ Terminal toggle (F12)"
echo -e "  ✓ Alt+Arrows window navigation"
echo -e "  ✓ Ctrl+C/Ctrl+V copy/paste"
echo -e "  ✓ BG.nvim (Kitty background sync)"
echo -e "  ✓ Kanagawa theme (wave, lotus, dragon)"
echo -e "  ✓ Full LSP support with Mason\n"

echo -e "${YELLOW}Quick Keybindings:${NC}"
echo -e "  F12              - Toggle terminal (horizontal split)"
echo -e "  Esc              - Exit terminal mode"
echo -e "  Tab              - Next buffer"
echo -e "  Shift+Tab        - Previous buffer"
echo -e "  Ctrl+Tab         - Next tab"
echo -e "  Ctrl+Shift+Tab   - Previous tab"
echo -e "  Alt+←/→/↑/↓      - Navigate windows"
echo -e "  Ctrl+G           - Open Git (LazyGit)"
echo -e "  Ctrl+T           - Toggle file explorer (Snacks)"
echo -e "  <leader>a        - Avante AI"
echo -e "  <leader>ff       - Find files"
echo -e "  <leader>fg       - Live grep"
echo -e "  Ctrl+C           - Copy"
echo -e "  Ctrl+V           - Paste\n"

echo -e "${BLUE}Git in Tree View (Snacks Explorer):${NC}"
echo -e "  M                - Modified file (yellow)"
echo -e "  A                - Added file (green)"
echo -e "  D                - Deleted file (red)"
echo -e "  ?                - Untracked file (white)"
echo -e "  ]g / [g          - Jump to next/prev git change"
echo -e "  I                - Toggle ignored files"
echo -e "  H                - Toggle hidden files\n"

echo -e "${BLUE}LSP Shortcuts:${NC}"
echo -e "  gd               - Go to definition"
echo -e "  K                - Hover documentation"
echo -e "  <leader>ca       - Code action"
echo -e "  <leader>rn       - Rename symbol\n"

echo -e "${BLUE}Next Steps:${NC}"
echo -e "  1. LSP servers are being installed now (takes 2-5 minutes)..."
echo -e "  2. Installation runs in the background"
echo -e "  3. Open Neovim: ${GREEN}nvim${NC}"
echo -e "  4. Check installation progress: ${GREEN}:Mason${NC}"
echo -e "  5. You should see all servers marked with ◍"
echo -e "  6. Once installed, type in CSS file and autocomplete works!"
echo -e "  7. Backup saved to: ${BACKUP_DIR}\n"

echo -e "${YELLOW}Language Servers to Install (run in nvim with :MasonInstall):${NC}"
echo -e "  pyright bash-language-server lua-language-server"
echo -e "  typescript-language-server html-lsp css-lsp"
echo -e "  clangd gopls rust-analyzer ruby-lsp"
echo -e "  json-lsp yaml-language-server terraform-ls\n"

echo -e "${BLUE}Theme Options:${NC}"
echo -e "  Current: Kanagawa Dragon (with Kitty integration)"
echo -e "  :colorscheme kanagawa       - Toggle between wave/dragon/lotus"
echo -e "  :set background=light       - Switch to light theme (Lotus)"
echo -e "  :set background=dark        - Switch to dark theme (Dragon)\n"

echo -e "${GREEN}Happy coding! 🚀${NC}\n"

# Create a helper script for Mason installation
cat > "$NVIM_CONFIG_DIR/install-lsp.sh" << 'LSPINSTALL'
#!/bin/bash
echo "Installing LSP servers with Mason..."
nvim --headless -c "MasonInstall pyright bashls lua_ls ts_ls html cssls clangd gopls rust-analyzer ruby-lsp jsonls yamlls terraform-ls jdtls" -c "qa"
echo "LSP servers installed!"
LSPINSTALL

chmod +x "$NVIM_CONFIG_DIR/install-lsp.sh"

echo -e "${YELLOW}To install LSP servers, run:${NC}"
echo -e "  ${GREEN}$NVIM_CONFIG_DIR/install-lsp.sh${NC}"
echo -e "  ${GREEN}or open nvim and run: :Mason${NC}\n"