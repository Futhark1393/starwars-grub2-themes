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

## 🎬 Theme Gallery

### Theme 01 — Tatooine Sunset
> *"Choose Your Path"*
> A cloaked figure gazes at the twin suns of Tatooine. Warm amber/gold menu positioned to the right of the figure.

![Theme 01](backgrounds/background1.png)

---

### Theme 02 — A New Hope
> *"A New Hope"*
> Classic original trilogy poster art with characters and Death Stars. Blue/gold menu on the left.

![Theme 02](backgrounds/background2.png)

---

### Theme 03 — Imperial Remnants
> *"Imperial Remnants"*
> Crashed TIE fighters in a misty, haunting graveyard landscape. Cold grey/blue palette.

![Theme 03](backgrounds/background3.png)

---

### Theme 04 — The Force Awakens
> *"The Force Awakens"*
> Beautiful four-panel art: blue forest, orange desert, green lake, red fire. Centered warm-neutral menu.

![Theme 04](backgrounds/background4.png)

---

### Theme 05 — Battle of Bespin
> *"Battle of Bespin"*
> Epic aerial battle with the Millennium Falcon and X-Wings over Cloud City. Golden palette.

![Theme 05](backgrounds/background5.png)

---

### Theme 06 — The Kessel Run
> *"The Kessel Run"*
> Millennium Falcon soaring over a desert landscape at sunset with twin suns. Sandy warm tones.

![Theme 06](backgrounds/background6.png)

---

### Theme 07 — The Dark Side
> *"The Dark Side"*
> Iconic Darth Vader profile portrait in a cold blue-black atmosphere. Red accent for selected items.

![Theme 07](backgrounds/background7.png)

---

### Theme 08 — A Galaxy Far Away
> *"A Galaxy Far Away"*
> The ultimate celebration — every Star Wars character in one epic group photo. Purple/blue palette with firework orange.

![Theme 08](backgrounds/background8.png)

---

### Theme 09 — Red Squadron
> *"Red Squadron"*
> X-Wing fighters in formation painted against a dramatic sunset sky. Warm brown/gold tones.

![Theme 09](backgrounds/background9.png)

---

### Theme 10 — That's No Moon
> *"That's No Moon"*
> The massive Death Star II rising over a blue night sky with AT-AT silhouettes. Deep blue monochrome.

![Theme 10](backgrounds/background10.png)

---

### Theme 11 — Ultimate Power
> *"Ultimate Power"*
> The classic Death Star floating in the stark void of space. Minimal grey/monochrome aesthetic.

![Theme 11](backgrounds/background11.png)

---

### Theme 12 — You Were The Chosen One
> *"You Were The Chosen One"*
> The legendary Obi-Wan vs Anakin lightsaber duel on the volcanic world of Mustafar. Intense red/orange/gold.

![Theme 12](backgrounds/background12.png)

---

### Theme 13 — Punch It, Chewie!
> *"Punch It, Chewie!"*
> Millennium Falcon cruising through the dark void of deep space. Subtle cool tones with cyan engine glow.

![Theme 13](backgrounds/background13.png)

---

### Theme 14 — Orbital Approach
> *"Orbital Approach"*
> Millennium Falcon descending into the atmosphere of a desert planet from orbit. Orange/brown with cyan accents.

![Theme 14](backgrounds/background14.png)

---

### Theme 15 — Do or Do Not
> *"Do or Do Not"*
> Master Yoda in the Dagobah swamp, wise and powerful. Green/olive palette matching the swamp environment.

![Theme 15](backgrounds/background15.png)

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
| `sudo ./manager.sh` | Interactive theme selector with visual menu |
| `sudo ./manager.sh install <1-15>` | Install a theme directly by number |
| `sudo ./manager.sh uninstall` | Remove the theme and restore default GRUB |
| `sudo ./manager.sh list` | Show all available themes (no sudo needed) |
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
