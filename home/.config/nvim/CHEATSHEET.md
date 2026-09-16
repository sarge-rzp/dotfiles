# Keybindings

Leader = `<Space>`. Press it and wait 300ms — which-key shows what's legal next.
Tags: **[c]** = custom (lua/config/keymaps.lua) · **[n]** = new (extra I enabled).

## Learn these twelve first

| Key | Does |
|---|---|
| `<Space>` | which-key popup — the only one you must memorise |
| `<Space><Space>` | Find file in project root |
| `<Space>/` | Grep the project |
| `<Space>e` | File explorer |
| `<Space>,` | Switch buffer |
| `gd` | Go to definition (`Ctrl-o` = back) |
| `K` | Hover docs |
| `<Space>ca` | Code action — the fix-it menu |
| `<Space>cr` | Rename symbol everywhere **[n]** |
| `<Space>gg` | Lazygit **[n]** |
| `s` | Flash — jump anywhere on screen |
| `<Space>qq` | Quit all |

## Files `<Space>f` / Search `<Space>s`

| Key | Does | | Key | Does |
|---|---|---|---|---|
| `ff` | Find files (root) | | `sg` | Grep (root) |
| `fF` | Find files (cwd) | | `sG` | Grep (cwd) |
| `fg` | Git-tracked files | | `sw` | Grep word under cursor |
| `fr` | Recent files | | `sb` | Fuzzy lines in buffer |
| `fb` | Open buffers | | `sr` | Project search & replace |
| `fe` / `fE` | Explorer root / cwd | | `sR` | Resume last picker |
| `fp` | Switch project **[n]** | | `sk` | Search all keymaps |
| `fc` | Open a config file | | `su` | Undo tree |
| `ft` | Floating terminal | | `st` | TODO comments |

## Code & LSP

`gd` definition · `gr` references · `gI` implementation · `gy` type def · `gD` declaration
`K` hover · `gK` signature · `]]` / `[[` next/prev use of symbol **[n]**

| Key | Does |
|---|---|
| `<Space>ca` | Code action |
| `<Space>cr` | Rename symbol **[n]** |
| `<Space>cR` | Rename file + fix imports |
| `<Space>co` | Organize imports |
| `<Space>cf` | Format now (also on save) |
| `<Space>cs` | Symbol outline |
| `<Space>cm` | Mason (manage servers) |
| `<Space>cp` / `cP` | Copy file path relative / absolute **[c]** |

## Diagnostics `<Space>x`

`]d` `[d` next/prev · `]e` `[e` errors only · `]w` `[w` warnings only
`<Space>cd` full message for line · `<Space>xx` all in a panel · `<Space>xX` this buffer
`<Space>xt` TODOs · `<Space>xq` quickfix · `<Space>xd` to loclist **[c]**

## Git `<Space>g`

| Key | Does |
|---|---|
| `gg` | Lazygit **[n]** |
| `gs` | Git status |
| `gb` | Blame line |
| `gd` | Diff hunks |
| `gl` / `gf` | Log / this file's history |
| `gB` / `gY` | Open / copy GitHub permalink |
| `gp` / `gi` | Pull requests / issues **[n]** |
| `]h` / `[h` | Next / prev changed hunk |
| `ghs` / `ghr` | Stage / reset hunk |
| `ghp` | Preview hunk inline |

## Harpoon **[n]** — pin the files you live in

`<Space>H` pin current file · `<Space>h` open list · `<Space>1`..`9` jump to pinned file N

## Buffers & windows

`H` / `L` prev / next buffer · `<Space>bd` close buffer · `<Space>bo` close others
`<Space>`` ` toggle last buffer · `Ctrl-h/j/k/l` move between splits
`<Space>-` split below · `<Space>|` split right · `<Space>wd` close window
`<Space>wm` zoom · `Ctrl-arrows` resize · `Ctrl-s` save (works in insert too)

## Editing

| Key | Does |
|---|---|
| `s` / `S` | Flash jump / to syntax node |
| `gcc` / `gc` | Comment line / selection |
| `gsa` `gsd` `gsr` | Add / delete / replace surrounding **[n]** |
| `Ctrl-Space` | Grow selection by syntax node |
| `Alt-j` / `Alt-k` | Move line or selection |
| `jk` | Leave insert mode **[c]** |
| `Ctrl-d` / `Ctrl-u` | Half-page scroll, stays centred **[c]** |
| `J` | Join lines, cursor stays put **[c]** |
| `<Space>p` (visual) | Paste over selection, keep register **[c]** |
| `<Space>D` | Delete without touching clipboard **[c]** |
| `<Space>o` / `O` | Blank line below / above **[c]** |
| `Esc Esc` (terminal) | Back to normal mode **[c]** |
| `gx` | Open URL/file under cursor |

## Test `<Space>t` & Debug `<Space>d` **[n]**

`tr` run nearest · `tt` run file · `ts` summary · `to` output · `tw` watch · `td` debug nearest
`db` breakpoint · `dc` continue · `di` step into · `dO` step over · `do` step out · `du` UI · `dt` terminate

## Toggles `<Space>u`

`uh` inlay hints · `uf` / `uF` format-on-save buffer / global · `ud` diagnostics
`uw` wrap · `ul` / `uL` line numbers · `uz` zen · `uC` preview colorschemes · `un` dismiss notifications

## Sessions

`<Space>qs` restore session for this dir · `<Space>ql` last session · `<Space>qq` quit all
`<Space>.` scratch buffer · `<Space>l` Lazy · `<Space>?` keymaps for this buffer

## Maintenance

- `:LazyExtras` — add a language or tool (`x` toggles, then restart)
- `:Lazy` — `U` update plugins, `x` remove orphans
- `:Mason` — language servers and formatters
- `:checkhealth` / `:LspInfo` — diagnose a broken setup
- Backup of the previous config: `~/.config/nvim.backup.*`
