return {
  -- ── Statusline: show the current LSP + a clock ──────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          if #clients == 0 then
            return ""
          end
          local names = vim.tbl_map(function(c)
            return c.name
          end, clients)
          return " " .. table.concat(names, ",")
        end,
        color = { fg = "#7aa2f7" },
      })
      table.insert(opts.sections.lualine_z, { "os.date('%H:%M')" })
      return opts
    end,
  },

  -- ── which-key: the popup that teaches you the keymaps ───────────────────
  -- This is your single most important beginner plugin. Press <leader> and
  -- WAIT — it lists every key you can press next. Do that instead of memorising.
  {
    "folke/which-key.nvim",
    opts = {
      preset = "helix", -- side panel, easiest to read
      delay = 300, -- ms before the popup appears
    },
  },

  -- ── Dashboard: recent files + projects on startup ───────────────────────
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      -- Scratch buffers (<leader>.) are great for jotting a query or snippet
      -- without creating a file. They persist per-project.
      scratch = { ft = "markdown" },
    },
  },
}
