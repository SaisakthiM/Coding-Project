return {
  {
    "folke/snacks.nvim",
    opts = {
      -- Disable the snacks explorer since we're using neo-tree
      explorer = {
        enabled = false,
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
              { icon = "  ", key = "g", desc = "Git (Neogit)", action = ":Neogit" },
              { icon = "  ", key = "t", desc = "File Tree (Neo-tree)", action = ":Neotree toggle" },
              { icon = "  ", key = "a", desc = "Avante AI", action = ":AvanteAsk" },
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