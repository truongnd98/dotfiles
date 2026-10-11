# dotfiles

macOS · zsh (zinit) · tmux · Alacritty · Neovim 0.12 · Go / Rust / TypeScript

## Cài trên máy mới

```sh
git clone <repo> ~/Desktop/personal-dev-config/dotfiles
cd ~/Desktop/personal-dev-config/dotfiles
./install.sh --dry-run   # xem trước
./install.sh
```

`install.sh` idempotent: chạy lại an toàn, file thật đang chắn đường thì được
backup thành `<file>.bak-<timestamp>` trước khi link. Các bước thủ công còn lại
(brew, `:MasonInstallAll`, `prefix + I` của tpm…) script in ra ở cuối.

## Layout symlink

Không đồng nhất một kiểu, và có lý do:

| Loại | Cái nào | Vì sao |
|---|---|---|
| symlink **thư mục** | `nvim`, `alacritty`, `bat` → `~/.config/<x>` | repo sở hữu toàn bộ thư mục |
| symlink **file** | `~/.zshrc`, `~/.ripgreprc`, `~/.tmux.conf` | đích nằm ngay ở `$HOME`, không phải trong `~/.config` |
| symlink **file** | `~/.config/helix/config.toml` | `~/.config/helix/` còn chứa `runtime` → trỏ sang bản helix build từ source, nên thư mục đó không thể là symlink vào repo |

## Có trong repo nhưng KHÔNG symlink

Giữ lại để dùng sau; bật thủ công khi cần:

- `.config/ghostty/` — ghostty chưa cài
- `.config/neovide/` — đã cài (cargo) nhưng chưa dùng config
- `.config/helix/languages.toml` — cần `biome` + `typescript-language-server`
- `.config/mini-nvim/` — config nvim tối giản, chạy song song bằng
  `NVIM_APPNAME=mini-nvim nvim`

## Không vendor vào repo

`install.sh` clone các thứ này:

- `.config/alacritty/themes` ← [alacritty/alacritty-theme](https://github.com/alacritty/alacritty-theme) (đã gitignore)
- `~/.tmux/plugins/tpm` ← [tmux-plugins/tpm](https://github.com/tmux-plugins/tpm)
- `~/fzf-git.sh` ← [junegunn/fzf-git.sh](https://github.com/junegunn/fzf-git.sh)

## Neovim

Config tự viết, **không** dùng LazyVim. lazy.nvim quản plugin, Mason quản
LSP/formatter/linter/DAP (`:MasonInstallAll` cài hết theo `lua/plugins/lsp.lua`).

- `lua/config/` — options, keymaps, autocmds (format-on-save Go/Rust, spell theo filetype)
- `lua/plugins/` — một file một chủ đề
- `lua/util/`   — helper dùng chung (`util.lsp` cho format / organizeImports)

Keymap đáng chú ý: leader = `<Space>`; `s` là prefix điều hướng window
(`sd`/`sv`/`sh`/`sj`/`sk`/`sl`); `<A-k>`/`<A-j>` move dòng; `<leader>m*` là menu
lệnh theo ngôn ngữ (Go / Rust / Cargo.toml); `<leader>n*` test (neotest);
`<leader>d*` debug (DAP); `<leader>g*` git (gitsigns); `<leader>f*` tìm kiếm
(telescope). `K` = LSP hover, `]q`/`[q`/`]d`/`[d`/`]h`/`[h` dùng bản built-in
của Nvim 0.11+ và gitsigns.
