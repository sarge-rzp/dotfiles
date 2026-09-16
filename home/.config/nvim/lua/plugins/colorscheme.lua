-- Colorscheme. Both of these are already installed by LazyVim, so switching is
-- free: change `colorscheme` below and restart, or preview live with
--   <leader>uC   (picker: cycle every installed theme with j/k)
return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "moon", -- "storm" | "moon" | "night" | "day"
      transparent = false, -- true = use your terminal's background
      styles = {
        -- Victor Mono (your installed Nerd Font) has a gorgeous italic cut,
        -- so leaning on italics here actually pays off.
        comments = { italic = true },
        keywords = { italic = true },
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-moon",
    },
  },
}
