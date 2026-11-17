# N30

Clean, professional Termux setup. Muted palette, Nerd Font icons, simple prompt, welcome message.

Author: **glngadttya**

## Install

```sh
pkg install -y git
git clone https://github.com/glngadttya/n30-brut.git
cd n30-brut
bash install.sh
```

Restart Termux after install.

## What it does

- muted dark palette (Nord-ish, easy on the eyes)
- JetBrains Mono Nerd Font Mono Regular
- `ls` / `ll` / `la` / `lt` use `eza` with file & folder icons
- `cat` uses `bat` for clean syntax highlighting
- small welcome message with author
- optional image via `n30set`

## Commands

| Command | Fungsi |
| --- | --- |
| `n30img` | Tampilkan gambar saat ini |
| `n30set <file>` | Ganti gambar |
| `n30off` | Hapus tema, balik ke default |

Tampilkan gambar tiap buka Termux:

```sh
echo 'N30_WALL=1' >> ~/.bashrc
```

## Uninstall

```sh
n30off && exit
```
