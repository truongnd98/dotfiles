#!/usr/bin/env bash
#
# Bootstrap dotfiles trên máy mới (macOS).
#
#   ./install.sh            # symlink + clone dependency
#   ./install.sh --dry-run  # chỉ in ra sẽ làm gì, không thay đổi gì
#
# Idempotent: chạy lại nhiều lần an toàn. Symlink đã đúng thì bỏ qua; file thật
# đang chắn đường thì backup thành <file>.bak-<timestamp> rồi mới link.
#
# Vì sao layout lẫn giữa symlink-directory và symlink-file:
#   - nvim/alacritty/bat: repo sở hữu TOÀN BỘ thư mục -> symlink cả directory.
#   - zsh/ripgrep/tmux:   file đích nằm ngay ở $HOME (~/.zshrc, ~/.ripgreprc,
#                         ~/.tmux.conf) nên chỉ link được từng file.
#   - helix:              ~/.config/helix còn chứa `runtime` -> symlink sang bản
#                         helix build từ source, tức thư mục đó KHÔNG thể là
#                         symlink vào repo. Link từng file.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

STAMP="$(date +%Y%m%d-%H%M%S)"
note() { printf '  %s\n' "$*"; }
run()  { if (( DRY_RUN )); then printf '  [dry-run] %s\n' "$*"; else eval "$@"; fi; }

# link <source trong repo> <đích>
link() {
  local src="$DOTFILES/$1" dst="$2"

  if [[ ! -e "$src" ]]; then
    note "BỎ QUA  $2  (không có $1 trong repo)"
    return
  fi

  if [[ -L "$dst" ]]; then
    if [[ "$(readlink "$dst")" == "$src" ]]; then
      note "ok      $dst"
      return
    fi
    note "relink  $dst  (đang trỏ $(readlink "$dst"))"
    run "rm '$dst'"
  elif [[ -e "$dst" ]]; then
    note "backup  $dst -> $dst.bak-$STAMP"
    run "mv '$dst' '$dst.bak-$STAMP'"
  fi

  run "mkdir -p '$(dirname "$dst")'"
  run "ln -s '$src' '$dst'"
  note "link    $dst -> $src"
}

# clone <repo url> <đích>
clone() {
  if [[ -d "$2/.git" ]]; then
    note "ok      $2"
  else
    note "clone   $1 -> $2"
    run "git clone --depth 1 '$1' '$2'"
  fi
}

echo "dotfiles: $DOTFILES"
(( DRY_RUN )) && echo "(dry-run: không thay đổi gì)"

echo
echo "== symlink thư mục (repo sở hữu toàn bộ) =="
link ".config/nvim"      "$HOME/.config/nvim"
link ".config/alacritty" "$HOME/.config/alacritty"
link ".config/bat"       "$HOME/.config/bat"

echo
echo "== symlink file (đích ở \$HOME) =="
link ".config/zsh/.zshrc"          "$HOME/.zshrc"
link ".config/ripgrep/.ripgreprc"  "$HOME/.ripgreprc"
link ".config/tmux/.tmux.conf"     "$HOME/.tmux.conf"

echo
echo "== symlink file (thư mục đích có nội dung ngoài repo) =="
link ".config/helix/config.toml"   "$HOME/.config/helix/config.toml"

echo
echo "== KHÔNG symlink (giữ trong repo, bật thủ công khi cần) =="
note "ghostty    -> ln -s \$DOTFILES/.config/ghostty   ~/.config/ghostty    (ghostty chưa cài)"
note "neovide    -> ln -s \$DOTFILES/.config/neovide   ~/.config/neovide    (đã cài nhưng chưa dùng config)"
note "mini-nvim  -> NVIM_APPNAME=mini-nvim nvim        (config nvim tối giản, chạy song song)"
note "helix/languages.toml  (cần biome + typescript-language-server mới dùng được)"

echo
echo "== dependency ngoài repo =="
clone "https://github.com/alacritty/alacritty-theme" "$DOTFILES/.config/alacritty/themes"
clone "https://github.com/tmux-plugins/tpm"          "$HOME/.tmux/plugins/tpm"
clone "https://github.com/junegunn/fzf-git.sh.git"   "$HOME/fzf-git.sh"

echo
echo "== bước thủ công còn lại =="
cat <<'EOS'
  brew install  fzf fd ripgrep bat eza zoxide tmux neovim jq
  brew install --cask alacritty font-maple-mono-nf
  zinit     : tự cài lần đầu mở zsh (xem .config/zsh/.zshrc)
  tmux      : mở tmux rồi bấm `prefix + I` (C-a I) để tpm cài plugin
  nvim      : mở nvim (lazy.nvim tự cài), rồi `:MasonInstallAll`
  copilot   : `:Copilot auth`
  rust      : rustup component add rust-analyzer rustfmt clippy
EOS
