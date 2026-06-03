# ★ Star Wars GRUB2 Theme Collection

> **15 hand-crafted GRUB2 themes** featuring iconic Star Wars scenes, each with a meticulously designed color palette, optimized menu positioning, and full keyboard shortcut guides.

![License](https://img.shields.io/badge/license-MIT-blue)
![Platform](https://img.shields.io/badge/platform-Fedora%20%7C%20RHEL%20%7C%20CentOS%20%7C%20Ubuntu%20%7C%20Arch-brightgreen)
![GRUB2](https://img.shields.io/badge/GRUB2-compatible-orange)

---

## 📋 Features

- 🎨 **15 Unique Themes** — Each with custom colors matched to its background
- 🖥️ **Smart Menu Positioning** — Menus placed in empty areas to preserve the artwork
- ⌨️ **Keyboard Shortcuts** — Permanent footer with `Enter`, `e`, `c` key guides
- 🔧 **One-Command Install** — Interactive CLI or direct `install <number>` syntax
- 🔄 **Easy Theme Switching** — Switch between themes with a single command
- 🗑️ **Clean Uninstall** — Fully reversible, restores default GRUB
- 📦 **Auto Dependencies** — Installs ImageMagick, fonts, and grub2-tools if missing

---

## 🚀 Quick Start

```bash
# Clone the repo
git clone https://github.com/Futhark1393/starwars-grub2-themes.git
cd starwars-grub2-themes

# Make scripts executable
chmod +x manager.sh scripts/*.sh

# Launch interactive theme selector
sudo ./manager.sh

# Or install a specific theme directly
sudo ./manager.sh install 7
```

---

## 📁 Project Structure

```
starwars-grub2-themes/
├── manager.sh              # Main CLI tool (run this!)
├── README.md               # This file
├── backgrounds/            # Source background images (15 PNGs)
│   ├── background1.png
│   ├── background2.png
│   └── ...
└── scripts/                # Theme installer scripts
    ├── theme-engine.sh     # Shared installer core (sourced by themes)
    ├── theme-01.sh         # Individual theme configs
    ├── theme-02.sh
    └── ...
```

---

## 🎬 Theme Gallery Archive

To keep this README clean and readable, the full collection of **15 high-resolution preview images** and their descriptions have been moved to a dedicated gallery archive.

👉 **[Click here to view the Star Wars Theme Gallery](GALLERY.md)** 👈

---

## ⌨️ GRUB2 Controls

Once your theme is installed, use these keys at the boot screen:

| Key | Action |
|-----|--------|
| `↑` `↓` | Navigate between entries |
| `Enter` | Boot selected entry |
| `e` | Edit boot parameters |
| `c` | Open GRUB command line |

---

## 🛠️ CLI Commands

| Command | Description |
|---------|-------------|
| `sudo ./manager.sh` | Interactive theme selector with pagination and preview |
| `sudo ./manager.sh install <1-15>` | Install a theme directly by number |
| `sudo ./manager.sh install random` | Install a randomly selected theme |
| `sudo ./manager.sh auto-random enable`| Enable auto-randomizer (changes theme on every boot) |
| `sudo ./manager.sh auto-random disable`| Disable auto-randomizer |
| `sudo ./manager.sh uninstall` | Remove the theme and restore default GRUB |
| `sudo ./manager.sh list` | Show all available themes |
| `./manager.sh --help` | Display help information |

---

## 📋 Requirements

| Dependency | Purpose | Auto-installed? |
|-----------|---------|:-:|
| **ImageMagick** | Background PNG conversion (24-bit RGB) | ✅ |
| **grub2-tools** | Font generation (`grub2-mkfont`) & config (`grub2-mkconfig`) | ✅ |
| **DejaVu Sans** | TTF font source for menu text | ✅ |

> All dependencies are automatically installed via `dnf`/`yum` if missing.

---

## 🔧 Technical Details

- **Image Format**: All backgrounds are converted to 24-bit RGB PNG (`-alpha off`) for GRUB2 compatibility
- **Selection Box**: Uses the GRUB2 9-slice pixmap system (`select_*.png`) for opaque, styled selection highlights
- **Fonts**: Dynamically generated PF2 bitmap fonts at 14pt, 22pt, and 28pt sizes
- **Layout**: Percentage-based positioning ensures consistency across all resolutions
- **Backup**: The installer automatically backs up `/etc/default/grub` before making changes

---

## 🗑️ Uninstalling

```bash
# Via the manager
sudo ./manager.sh uninstall

# This will:
# 1. Remove /boot/grub2/themes/starwars-grub/
# 2. Clean GRUB_THEME from /etc/default/grub
# 3. Regenerate grub.cfg
```

---

## 🤝 Contributing

1. Add your background image to `backgrounds/` as `background<N>.png`
2. Create a matching `scripts/theme-<N>.sh` following the existing format
3. Update the `THEMES` array in `manager.sh`
4. Submit a pull request!

---

## 📜 License

This project is licensed under the MIT License. Background images are fan art and may be subject to their respective copyright holders.

---

<p align="center">
  <i>"May the Force be with you."</i>
</p>
