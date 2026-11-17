#!/data/data/com.termux/files/usr/bin/env bash
# N30-BRUT - full neo-brutalism styling for Termux
# Usage: bash install.sh

set -e

if [ -z "${PREFIX:-}" ] || [ ! -d "$PREFIX" ]; then
  echo "This script is for Termux only." >&2
  exit 1
fi

pkg install -y chafa wget unzip >/dev/null
mkdir -p "$HOME/.termux"

# ---- colors ----
cat > "$HOME/.termux/colors.properties" <<'EOF'
background=#101010
foreground=#F2F2ED
cursor=#F5FF00
color0=#0A0A0A
color1=#FF2E63
color2=#B4FF39
color3=#F5FF00
color4=#3D5AFE
color5=#D500F9
color6=#00E5FF
color7=#E8E8E3
color8=#4A4A4A
color9=#FF6B9A
color10=#D2FF72
color11=#FFF176
color12=#7C9CFF
color13=#E040FB
color14=#6BF0FF
color15=#FFFFFF
EOF

# ---- extra keys (chunky labels) ----
cat > "$HOME/.termux/termux.properties" <<'EOF'
extra-keys = [[ \
 {key: ESC, display: ESC}, {key: TAB, display: TAB}, \
 {key: CTRL, display: CTL}, {key: ALT, display: ALT}, \
 {key: LEFT, display: <<}, {key: DOWN, display: v}, \
 {key: UP, display: ^}, {key: RIGHT, display: >>} \
]]
EOF

# ---- font: JetBrains Mono Nerd Font Mono Bold ----
if [ ! -f "$HOME/.termux/font.ttf" ]; then
  FONT_DIR="$HOME/.cache/n30-font"
  mkdir -p "$FONT_DIR"
  if wget -q -O "$FONT_DIR/jetbrains.zip" \
      https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip; then
    unzip -oq "$FONT_DIR/jetbrains.zip" -d "$FONT_DIR/out"
    FONT="$FONT_DIR/out/JetBrainsMonoNerdFontMono-Bold.ttf"
    [ -f "$FONT" ] || FONT="$FONT_DIR/out/JetBrainsMonoNerdFontMono-Regular.ttf"
    [ -f "$FONT" ] && cp "$FONT" "$HOME/.termux/font.ttf"
  fi
fi

# ---- custom image (demo, replace with brutset) ----
base64 -d > "$HOME/.termux/brutal.png" <<'EOF'
iVBORw0KGgoAAAANSUhEUgAAAKAAAABaCAMAAAAIGK1gAAAADFBMVEUQEBD1/wD/LmPo6OPxcDYAAAAAfklEQVR42u3aSQqAMBBFwY7e/86CuIwkLgI/WO8EtWoydNVTu6uAXiSAgICAi4AtPEBAwBHQHAQEBAQEBEwGHpMBAiYBz88BAgImA/uXSUBAQEBAQEBAwL8AnagBAfcDet0CBEwC+icBBAQEBARcDbQ/CAhoh9WgBgQE3Bp4AUkTJLEFv2mWAAAAAElFTkSuQmCC
EOF

# ---- shell config ----
touch "$HOME/.bashrc"
sed -i '/# >>> N30-BRUT >>>/,/# <<< N30-BRUT <<</d' "$HOME/.bashrc"
cat >> "$HOME/.bashrc" <<'EOF'

# >>> N30-BRUT >>>
export BRUT_STARTUP="${BRUT_STARTUP:-1}"

PS1='\n\[\e[1;33m\]██[ N30-BRUT ]██\[\e[0m\] \[\e[1;36m\]\u@\h\[\e[0m\] \[\e[1;35m\]\w\[\e[0m\]\n\[\e[1;33m\]##> \[\e[0m\]'
PS2='\[\e[1;33m\]##.. \[\e[0m\]'

alias ll='ls -l --color=auto'
alias la='ls -A --color=auto'
alias grep='grep --color=auto'

brutbanner() {
  printf '\n\033[1;33m##############################\n#  N30-BRUT // RAW MODE     #\n##############################\033[0m\n'
}

brutimg() {
  local f="${1:-$HOME/.termux/brutal.png}"
  [ -f "$f" ] || { printf 'brutimg: image not found: %s\n' "$f"; return 1; }
  chafa --size=36x12 --symbols=block --colors=16 "$f"
}

brutset() {
  [ -n "$1" ] || { printf 'usage: brutset /path/to/image.png\n'; return 1; }
  cp "$1" "$HOME/.termux/brutal.png" && brutimg
}

brutoff() {
  sed -i '/# >>> N30-BRUT >>>/,/# <<< N30-BRUT <<</d' "$HOME/.bashrc"
  rm -f "$HOME/.termux/colors.properties" \
        "$HOME/.termux/termux.properties" \
        "$HOME/.termux/brutal.png" \
        "$HOME/.termux/font.ttf"
  command -v termux-reload-settings >/dev/null 2>&1 && termux-reload-settings || true
  printf 'N30-BRUT removed. Restart Termux.\n'
}

if [ "$BRUT_STARTUP" = "1" ] && [ -f "$HOME/.termux/brutal.png" ]; then
  brutbanner
  brutimg
  printf '\n'
fi
# <<< N30-BRUT <<<
EOF

command -v termux-reload-settings >/dev/null 2>&1 && termux-reload-settings || true

printf '\n'
chafa --size=36x12 --symbols=block --colors=16 "$HOME/.termux/brutal.png"
printf '\n[N30-BRUT] installed. Restart Termux.\n'
printf 'Commands: brutimg | brutset <file> | brutoff\n'
printf 'Matikan banner: echo "BRUT_STARTUP=0" >> ~/.bashrc\n'
