#!/data/data/com.termux/files/usr/bin/env bash
# N30 - clean, professional Termux setup
# Usage: bash install.sh

set -e

if [ -z "${PREFIX:-}" ] || [ ! -d "$PREFIX" ]; then
  echo "This script is for Termux only." >&2
  exit 1
fi

AUTHOR="glngadttya"

pkg install -y eza bat wget unzip chafa >/dev/null 2>&1 || true
mkdir -p "$HOME/.termux"

# ---- muted, professional palette ----
cat > "$HOME/.termux/colors.properties" <<'EOF'
background=#151821
foreground=#D8DEE9
cursor=#A3BE8C
color0=#1E222D
color1=#BF616A
color2=#A3BE8C
color3=#EBCB8B
color4=#81A1C1
color5=#B48EAD
color6=#88C0D0
color7=#ECEFF4
color8=#4C566A
color9=#D08770
color10=#A3BE8C
color11=#EBCB8B
color12=#81A1C1
color13=#B48EAD
color14=#88C0D0
color15=#FFFFFF
EOF

# ---- clean extra keys ----
cat > "$HOME/.termux/termux.properties" <<'EOF'
extra-keys = [[ \
 {key: ESC}, {key: TAB}, {key: CTRL}, {key: ALT}, \
 {key: LEFT}, {key: DOWN}, {key: UP}, {key: RIGHT} \
]]
EOF

# ---- font: JetBrains Mono Nerd Font Mono (Regular) ----
FONT_DIR="$HOME/.cache/n30-font"
mkdir -p "$FONT_DIR"
rm -f "$HOME/.termux/font.ttf"
if wget -q -O "$FONT_DIR/jetbrains.zip" \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip; then
  unzip -oq "$FONT_DIR/jetbrains.zip" -d "$FONT_DIR/out"
  FONT="$FONT_DIR/out/JetBrainsMonoNerdFontMono-Regular.ttf"
  [ -f "$FONT" ] && cp "$FONT" "$HOME/.termux/font.ttf"
fi

# ---- optional demo image for n30set ----
base64 -d > "$HOME/.termux/n30.png" <<'EOF'
iVBORw0KGgoAAAANSUhEUgAAAKAAAABaCAMAAAAIGK1gAAAADFBMVEUQEBD1/wD/LmPo6OPxcDYAAAAAfklEQVR42u3aSQqAMBBFwY7e/86CuIwkLgI/WO8EtWoydNVTu6uAXiSAgICAi4AtPEBAwBHQHAQEBAQEBEwGHpMBAiYBz88BAgImA/uXSUBAQEBAQEBAwL8AnagBAfcDet0CBEwC+icBBAQEBARcDbQ/CAhoh9WgBgQE3Bp4AUkTJLEFv2mWAAAAAElFTkSuQmCC
EOF

# ---- shell config ----
touch "$HOME/.bashrc"
sed -i '/# >>> N30-BRUT >>>/,/# <<< N30-BRUT <<</d' "$HOME/.bashrc"
sed -i '/# >>> N30 >>>/,/# <<< N30 <<</d' "$HOME/.bashrc"
cat >> "$HOME/.bashrc" <<EOF

# >>> N30 >>>
export N30_AUTHOR="$AUTHOR"
export N30_WALL="\${N30_WALL:-0}"

PS1='\[\e[38;5;109m\]\w\[\e[0m\]\n\[\e[38;5;150m\]❯ \[\e[0m\]'
PS2='\[\e[38;5;109m\]  · \[\e[0m\]'

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons --group-directories-first --color=always'
  alias ll='eza -l --icons --group-directories-first --color=always --header'
  alias la='eza -a --icons --group-directories-first --color=always'
  alias lt='eza --tree --icons --color=always --level=2'
else
  alias ls='ls --color=auto'
  alias ll='ls -l --color=auto'
  alias la='ls -A --color=auto'
fi

if command -v bat >/dev/null 2>&1; then
  alias cat='bat --color=always --style=plain'
fi

alias df='df -h'
alias du='du -h'

n30img() {
  local f="\${1:-$HOME/.termux/n30.png}"
  [ -f "\$f" ] || { printf 'n30img: file not found: %s\n' "\$f"; return 1; }
  chafa --size=32x10 --symbols=block --colors=16 "\$f"
}

n30set() {
  [ -n "\$1" ] || { printf 'usage: n30set /path/to/image.png\n'; return 1; }
  cp "\$1" "$HOME/.termux/n30.png" && n30img
}

n30off() {
  sed -i '/# >>> N30-BRUT >>>/,/# <<< N30-BRUT <<</d' "$HOME/.bashrc"
  sed -i '/# >>> N30 >>>/,/# <<< N30 <<</d' "$HOME/.bashrc"
  rm -f "$HOME/.termux/colors.properties" \
        "$HOME/.termux/termux.properties" \
        "$HOME/.termux/font.ttf" \
        "$HOME/.termux/n30.png"
  command -v termux-reload-settings >/dev/null 2>&1 && termux-reload-settings || true
  printf 'N30 removed. Restart Termux.\n'
}

if [ -t 1 ]; then
  printf '\n\033[38;5;109m────────────────────────────────\033[0m\n'
  printf ' \033[1;37mn30\033[0m  ready   ·   author \033[38;5;150m%s\033[0m\n' "$N30_AUTHOR"
  printf '\033[38;5;109m────────────────────────────────\033[0m\n'
  if [ "\$N30_WALL" = "1" ] && [ -f "$HOME/.termux/n30.png" ]; then
    n30img
  fi
  printf '\n'
fi
# <<< N30 <<<
EOF

command -v termux-reload-settings >/dev/null 2>&1 && termux-reload-settings || true

printf '\n\033[38;5;109m────────────────────────────────\033[0m\n'
printf ' \033[1;37mn30\033[0m  installed   ·   author \033[38;5;150m%s\033[0m\n' "$AUTHOR"
printf '\033[38;5;109m────────────────────────────────\033[0m\n'
printf 'Commands: n30set <file> | n30img | n30off\n'
