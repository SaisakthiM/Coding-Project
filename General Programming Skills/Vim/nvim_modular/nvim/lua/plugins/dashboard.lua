return {
  {
    "goolord/alpha-nvim",
    lazy = false,
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      
      -- ASCII Art Header
      dashboard.section.header.val = {
        "███████╗ █████╗ ██╗██╗   ██╗██╗███╗   ███╗",
        "██╔════╝██╔══██╗██║██║   ██║██║████╗ ████║",
        "███████╗███████║██║██║   ██║██║██╔████╔██║",
        "╚════██║██╔══██║██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "███████║██║  ██║██║ ╚████╔╝ ██║██║ ╚═╝ ██║",
        "╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
        "      ⚡ Saivim — Kanagawa Edition",
      }
      
      -- Buttons
      dashboard.section.buttons.val = {
        dashboard.button("F", "📁 Find file", ":Telescope find_files cwd=~/Coding-Project<CR>"),
        dashboard.button("R", "🕘 Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("G", "🌲 Git tree", ":Neogit<CR>"),
        dashboard.button("T", "🗂️  File tree", ":Neotree toggle<CR>"),
        dashboard.button("N", "📝 New file", ":ene | startinsert<CR>"),
        dashboard.button("S", "💾 Restore session", ":lua require('persistence').load()<CR>"),
        dashboard.button("c", "⚙️  Config", ":edit ~/.config/nvim/init.lua<CR>"),
        dashboard.button("q", "❌ Quit", ":qa<CR>"),
      }
      
      -- Footer
      dashboard.section.footer.val = "Happy coding, Sai! 🚀"
      
      -- Layout
      dashboard.config.layout = {
        { type = "padding", val = 2 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }
      
      -- Disable folding on alpha buffer
      vim.cmd([[
        autocmd FileType alpha setlocal nofoldenable
      ]])
      
      alpha.setup(dashboard.config)
    end,
  },
}
