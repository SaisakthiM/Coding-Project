return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        transparent = true,
        theme = "wave",
        overrides = function(colors)
          local soft_fg = "#C8C093"
          
          return {
            -- Base
            Normal = { bg = "NONE", fg = soft_fg },
            NormalNC = { bg = "NONE", fg = soft_fg },
            NormalFloat = { bg = "NONE", fg = soft_fg },
            
            -- Syntax
            Comment = { fg = "#727169", italic = true },
            String = { fg = "#98BB6C" },
            Number = { fg = "#D27E99" },
            Boolean = { fg = "#FFA066" },
            Function = { fg = "#7E9CD8" },
            Keyword = { fg = "#957FB8" },
            Operator = { fg = "#C34043" },
            Type = { fg = "#7AA89F" },
            Identifier = { fg = soft_fg },
            
            -- UI - LINE NUMBERS CHANGED HERE
            LineNr = { bg = "NONE", fg = "#727169" },  -- Softer grey for line numbers
            CursorLineNr = { bg = "NONE", fg = "#C8C093", bold = true },  -- Current line number
            SignColumn = { bg = "NONE" },
            StatusLine = { bg = "NONE", fg = soft_fg },
            StatusLineNC = { bg = "NONE", fg = "#727169" },
            WinSeparator = { bg = "NONE", fg = "#54546D" },
            VertSplit = { bg = "NONE", fg = "#54546D" },
            
            -- Float
            FloatBorder = { bg = "NONE", fg = "#54546D" },
            FloatTitle = { bg = "NONE", fg = "#7E9CD8", bold = true },
            
            -- Pmenu
            Pmenu = { bg = "#16161D", fg = soft_fg },
            PmenuSel = { bg = "#2D4F67", fg = "#DCD7BA", bold = true },
            PmenuSbar = { bg = "#16161D" },
            PmenuThumb = { bg = "#727169" },
            
            -- Neo-tree
            NeoTreeNormal = { bg = "NONE", fg = soft_fg },
            NeoTreeNormalNC = { bg = "NONE", fg = soft_fg },
            NeoTreeBorder = { bg = "NONE", fg = "#54546D" },
            NeoTreeWinSeparator = { bg = "NONE", fg = "#54546D" },
            NeoTreeDirectoryName = { fg = "#7E9CD8" },
            NeoTreeDirectoryIcon = { fg = "#DCA561" },
            NeoTreeFileName = { fg = soft_fg },
            NeoTreeFileIcon = { fg = "#957FB8" },
            NeoTreeGitAdded = { fg = "#76946A" },
            NeoTreeGitDeleted = { fg = "#C34043" },
            NeoTreeGitModified = { fg = "#DCA561" },
            NeoTreeGitUntracked = { fg = "#7AA89F" },
            NeoTreeIndentMarker = { fg = "#54546D" },
            
            -- Avante
            AvanteWinBar = { fg = "#7E9CD8", bg = "NONE" },
            AvanteWinBarNC = { fg = "#727169", bg = "NONE" },
            AvanteSeparator = { fg = "#54546D", bg = "NONE" },
            AvanteTitle = { fg = "#7E9CD8", bg = "NONE", bold = true },
            
            -- Diff
            DiffAdd = { bg = "#2D4F36", fg = "NONE" },
            DiffDelete = { bg = "#43242B", fg = "NONE" },
            DiffChange = { bg = "#2D3F4F", fg = "NONE" },
            DiffText = { bg = "#3F4F5F", fg = "NONE" },
            
            -- Git signs
            GitSignsAdd = { fg = "#76946A", bg = "NONE" },
            GitSignsChange = { fg = "#DCA561", bg = "NONE" },
            GitSignsDelete = { fg = "#C34043", bg = "NONE" },
          }
        end,
      })
      
      vim.cmd.colorscheme("kanagawa-wave")
      
      -- Force terminal colors
      vim.g.terminal_color_0 = "#16161D"
      vim.g.terminal_color_1 = "#C34043"
      vim.g.terminal_color_2 = "#76946A"
      vim.g.terminal_color_3 = "#C0A36E"
      vim.g.terminal_color_4 = "#7E9CD8"
      vim.g.terminal_color_5 = "#957FB8"
      vim.g.terminal_color_6 = "#7AA89F"
      vim.g.terminal_color_7 = "#C8C093"
      vim.g.terminal_color_8 = "#727169"
      vim.g.terminal_color_9 = "#E82424"
      vim.g.terminal_color_10 = "#98BB6C"
      vim.g.terminal_color_11 = "#DCA561"
      vim.g.terminal_color_12 = "#7FB4CA"
      vim.g.terminal_color_13 = "#938AA9"
      vim.g.terminal_color_14 = "#7AA89F"
      vim.g.terminal_color_15 = "#C8C093"
    end,
  },
}
