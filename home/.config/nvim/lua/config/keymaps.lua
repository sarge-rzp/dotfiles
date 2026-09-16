-- Loaded on the VeryLazy event, AFTER LazyVim's own ~200 keymaps.
-- Anything here wins over a LazyVim default with the same lhs.
-- See the full default list: <leader>? (buffer keymaps) or :Telescope keymaps
--
-- Keep this file small. Every line you add is a line you have to remember.

local map = vim.keymap.set

-- ── Insert-mode escape ────────────────────────────────────────────────────
-- Optional ergonomic. "jk" typed fast leaves insert mode, so your hand never
-- leaves home row. Delete these two lines if you already like <Esc>/<C-[>.
map("i", "jk", "<Esc>", { desc = "Escape insert mode" })

-- ── Keep the cursor centred while moving ──────────────────────────────────
-- Half-page jumps normally throw your eyes around. `zz` re-centres the line,
-- so the cursor stays in the middle of the screen and you never lose your place.
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centred)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centred)" })

-- Joining lines normally yanks the cursor to the join point. `mz...`z` sets a
-- mark, joins, then jumps back — so the cursor does not move.
map("n", "J", "mzJ`z", { desc = "Join line below (keep cursor)" })

-- ── Paste without losing your clipboard ───────────────────────────────────
-- Default: selecting text and pressing `p` overwrites your register with the
-- text you just replaced. This deletes into the black-hole register (_) first,
-- so you can paste the same thing over and over.
map("x", "<leader>p", [["_dP]], { desc = "Paste over selection (keep register)" })

-- ── Delete without yanking ────────────────────────────────────────────────
map({ "n", "x" }, "<leader>D", [["_d]], { desc = "Delete into black hole" })

-- ── Blank lines without entering insert mode ──────────────────────────────
map("n", "<leader>o", "o<Esc>", { desc = "Blank line below" })
map("n", "<leader>O", "O<Esc>", { desc = "Blank line above" })

-- ── Terminal ──────────────────────────────────────────────────────────────
-- Inside a :terminal, <Esc> is passed to the shell. Double-tap to get out.
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Terminal: to normal mode" })

-- ── Copy the current file's path (useful for pasting into Slack/PRs) ──────
map("n", "<leader>cp", function()
  local path = vim.fn.expand("%:.") -- relative to cwd
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy relative path" })

map("n", "<leader>cP", function()
  local path = vim.fn.expand("%:p") -- absolute
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy absolute path" })

-- ── Diagnostics: send everything wrong in this buffer to a list ───────────
-- <leader>xx (Trouble) is the pretty version; this is the plain quickfix one.
map("n", "<leader>xd", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
