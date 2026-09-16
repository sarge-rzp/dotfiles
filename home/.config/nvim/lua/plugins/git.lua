-- Git beyond what LazyVim ships. LazyVim already gives you lazygit (<leader>gg),
-- gitsigns hunks (]h / [h) and the GitHub extras (<leader>gB / gY / gp / gi).
-- These two fill the gaps that were actually missing.
return {
  -- ── Inline blame on the current line ──────────────────────────────────────
  -- gitsigns is already installed by LazyVim with blame turned off; <leader>ghb
  -- shows it on demand. Turning it on permanently answers "who wrote this and
  -- why" without a keystroke, which is the question you ask most while reading
  -- unfamiliar code. Virtual text only — it never touches the buffer.
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 400, -- ms after the cursor settles; LazyVim/gitsigns default is 1000
        virt_text_pos = "eol",
      },
    },
  },

  -- ── diffview: real side-by-side diffs ─────────────────────────────────────
  -- LazyVim has no equivalent. <leader>gd (gitsigns) shows hunks in one buffer
  -- and <leader>gf lists commits in a picker, but neither gives you the
  -- two-pane, whole-branch view you want when reviewing a PR before approving.
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Diffview (working tree)" },
      { "<leader>gV", "<cmd>DiffviewOpen origin/HEAD...HEAD<cr>", desc = "Diffview (branch vs origin)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview file history" },
    },
    opts = {
      enhanced_diff_hl = true, -- colour by word, not just by line
      view = {
        merge_tool = { layout = "diff3_mixed" }, -- show the common ancestor during conflicts
      },
    },
  },
}
