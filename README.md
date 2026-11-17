# N30-BRUT

Neo-brutalism styling for Termux. Hard edges, acid yellow, hot pink, concrete black, chunky Nerd Font, custom image banner. No soft corners.

Termux has no native terminal background image, so images are rendered as ANSI blocks with `chafa`.

## Install

```sh
pkg install -y git
git clone https://github.com/OWNER/REPO.git
cd REPO
bash install.sh
```

Restart Termux after install.

## What it changes

- `~/.termux/colors.properties` - brutalist palette
- `~/.termux/font.ttf` - JetBrains Mono Nerd Font Mono Bold
- `~/.termux/termux.properties` - chunky extra keys
- `~/.termux/brutal.png` - default demo image
- `~/.bashrc` - block prompt, banner, aliases, helper functions

## Commands

| Command | Fungsi |
| --- | --- |
| `brutimg` | Tampilkan gambar saat ini |
| `brutset <file>` | Ganti gambar (png/jpg/webp) |
| `brutoff` | Hapus tema + font, balik ke default |
| `brutbanner` | Cetak ulang banner |

## Custom image

```sh
termux-setup-storage
brutset ~/storage/shared/Pictures/foto.jpg
```

Banner muncul tiap buka Termux. Matikan:

```sh
echo 'BRUT_STARTUP=0' >> ~/.bashrc
```

## Uninstall

```sh
brutoff && exit
```
