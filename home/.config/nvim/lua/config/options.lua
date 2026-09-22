-- Loaded BEFORE lazy.nvim starts.
-- LazyVim already sets ~55 sane options (see :h lazyvim-options or
-- ~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/config/options.lua).
-- Only genuine additions / overrides live here.

local opt = vim.opt

-- ── PATH ──────────────────────────────────────────────────────────────────
-- Neovim inherits the PATH of whatever launched it. Tools installed by
-- `go install` land in ~/go/bin, which is often missing from a GUI/login
-- shell's PATH. Prepending here means gopls is always found, regardless of
-- how nvim was started.
local go_bin = vim.fn.expand("~/go/bin")
if vim.fn.isdirectory(go_bin) == 1 and not vim.env.PATH:find(go_bin, 1, true) then
  vim.env.PATH = go_bin .. ":" .. vim.env.PATH
end

-- ── Leader keys ───────────────────────────────────────────────────────────
-- <leader> = Space, <localleader> = \  (LazyVim sets these; restated so you
-- know where they come from when you read a keymap like "<leader>ff").
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- ── Editing ───────────────────────────────────────────────────────────────
opt.scrolloff = 8 -- keep 8 lines above/below cursor (LazyVim: 4)
opt.textwidth = 0 -- never hard-wrap for me automatically
opt.colorcolumn = "100" -- visual guide at col 100; delete if you find it noisy

-- ── Mouse ─────────────────────────────────────────────────────────────────
-- LazyVim sets mouse="a". Turning it off keeps a terminal multiplexer or
-- remote-session host (Herdr) from capturing the mouse, which is what swallows
-- <Esc> and leaves you stuck in insert mode. Also stops a stray trackpad brush
-- from moving the cursor mid-edit. Set back to "a" if you want scroll/click.
opt.mouse = ""

-- Persist undo history across restarts. `undofile` is on in LazyVim; this just
-- pins the location so it survives a config wipe.
opt.undodir = vim.fn.stdpath("state") .. "/undo"

-- ── Search ────────────────────────────────────────────────────────────────
opt.hlsearch = true -- highlight matches (<Esc> clears it, see keymaps)

-- ── Splits ────────────────────────────────────────────────────────────────
opt.splitbelow = true -- horizontal splits open below
opt.splitright = true -- vertical splits open to the right

-- ── Diagnostics: show the message inline, not just a gutter icon ──────────
-- This is the single biggest "I can see what's wrong" upgrade for a beginner.
vim.diagnostic.config({
  virtual_text = { spacing = 4, prefix = "●", source = "if_many" },
  severity_sort = true,
  float = { border = "rounded", source = true },
})

-- ── Formatting ────────────────────────────────────────────────────────────
-- Format on save is ON by default in LazyVim (conform.nvim).
-- Toggle it per-buffer with <leader>uf, globally with <leader>uF.
vim.g.autoformat = true

-- ── Mason's bin dir on PATH, before any plugin spawns a tool ───────────
-- mason.nvim prepends this itself, but it is lazy-loaded on `:Mason`, so
-- anything that shells out earlier (notably `:TSUpdate` calling `tree-sitter`)
-- fails with ENOENT. Doing it here makes mason-installed tools resolvable from
-- the moment Neovim starts.
do
  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
  if vim.uv.fs_stat(mason_bin) then
    vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
  end
end

-- ── LazyVim feature switches ──────────────────────────────────────────────
vim.g.lazyvim_picker = "snacks" -- file/grep picker engine
vim.g.lazyvim_cmp = "blink.cmp" -- completion engine (fast, Rust-backed)
vim.g.snacks_animate = true -- smooth scroll + indent animations

-- ── Go writes tabs, not spaces (gofmt is non-negotiable about this) ───────
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "gomod", "gowork", "gotmpl", "make" },
  callback = function()
    vim.bo.expandtab = false
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
  end,
})
