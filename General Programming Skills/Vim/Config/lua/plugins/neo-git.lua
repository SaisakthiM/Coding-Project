return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<M-g>", "<cmd>Neogit<cr>", desc = "Neogit" },
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Neogit Commit" },
      { "<leader>gp", "<cmd>Neogit push<cr>", desc = "Neogit Push" },
      { "<leader>gl", "<cmd>Neogit pull<cr>", desc = "Neogit Pull" },
    },
    config = function()
      require("neogit").setup({
        -- Use split (horizontal)
        kind = "split",
        
        -- Compact signs
        signs = {
          hunk = { "", "" },
          item = { "▸", "▾" },
          section = { "▸", "▾" },
        },
        
        -- Graph style
        graph_style = "unicode",
        
        -- Integrations
        integrations = {
          telescope = true,
          diffview = true,
        },
        
        -- Hide empty/less important sections
        sections = {
          sequencer = {
            folded = false,
            hidden = false,
          },
          untracked = {
            folded = false,
            hidden = false,
          },
          unstaged = {
            folded = false,
            hidden = false,
          },
          staged = {
            folded = false,
            hidden = false,
          },
          stashes = {
            folded = true,
            hidden = false,
          },
          unpulled_upstream = {
            folded = true,
            hidden = false,
          },
          unmerged_upstream = {
            folded = true,
            hidden = false,
          },
          unpulled_pushRemote = {
            folded = true,
            hidden = false,
          },
          unmerged_pushRemote = {
            folded = true,
            hidden = false,
          },
          recent = {
            folded = true,
            hidden = false,
          },
          rebase = {
            folded = true,
            hidden = false,
          },
        },
        
        -- Mappings
        mappings = {
          status = {
            ["q"] = "Close",
            ["<tab>"] = "Toggle",
            ["x"] = "Discard",
            ["s"] = "Stage",
            ["S"] = "StageUnstaged",
            ["u"] = "Unstage",
            ["U"] = "UnstageStaged",
            ["<c-r>"] = "RefreshBuffer",
            ["1"] = "Depth1",
            ["2"] = "Depth2",
            ["3"] = "Depth3",
            ["4"] = "Depth4",
          },
        },
      })
      
      -- Autocmd to set a bigger size and remove padding
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "Neogit*",
        callback = function()
          -- Remove all extra spacing
          vim.opt_local.signcolumn = "no"
          vim.opt_local.foldcolumn = "0"
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          vim.opt_local.fillchars = "eob: " -- Remove ~ at end of buffer
          
          -- Set a larger fixed height (adjust this number to your preference)
          vim.cmd("resize 20")  -- 20 lines height, increase/decrease as needed
        end,
      })
    end,
  },
}