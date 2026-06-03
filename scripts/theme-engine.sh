#!/usr/bin/env bash
# ============================================================================
#  Star Wars GRUB2 Theme Engine — Shared Installer Core
#  Author: Futhark1393
#  Target: Fedora (GRUB2) — also works on RHEL, CentOS, Ubuntu, Arch
#
#  This file is NOT run directly. It is sourced by individual theme scripts
#  (theme-01.sh, theme-02.sh, …) which define the visual configuration
#  (colors, positioning, title) and call install_theme().
#
#  Technical notes:
#    - GRUB2 only supports 24-bit RGB PNG (no alpha channel)
#    - Color codes must be #RRGGBB (6 hex digits, no 8-digit RGBA)
#    - Selection box uses 9-slice pixmap convention (select_*.png)
#    - Fonts are converted from TTF → PF2 via grub2-mkfont
# ============================================================================

set -euo pipefail

# ----- Resolve Paths --------------------------------------------------------

ENGINE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "${ENGINE_DIR}")"
BACKGROUNDS_DIR="${PROJECT_ROOT}/backgrounds"

# ----- GRUB2 System Paths ---------------------------------------------------

THEME_NAME="starwars-grub"
THEME_DIR="/boot/grub2/themes/${THEME_NAME}"
GRUB_DEFAULT_FILE="/etc/default/grub"
GRUB_CFG="/boot/grub2/grub.cfg"
FONT_NAME="DejaVuSans"
FONT_SIZE_MENU=22
FONT_SIZE_TITLE=28
FONT_SIZE_SMALL=14

# ============================================================================
#  install_theme()  —  Main installer function
#
#  Expected variables set by the calling theme script:
#    THEME_TITLE          - Title text above the menu (e.g. "Choose Your Path")
#    BG_FILE              - Background filename in backgrounds/ (e.g. "background1.png")
#    COLOR_ITEM           - Menu item text color (#RRGGBB)
#    COLOR_ITEM_SELECTED  - Selected item text color (#RRGGBB)
#    COLOR_TITLE          - Title label color (#RRGGBB)
#    COLOR_TIMER          - Countdown timer color (#RRGGBB)
#    COLOR_INFO           - Footer info text color (#RRGGBB)
#    COLOR_SELECT_BG      - Selection box background (#RRGGBB)
#    COLOR_SELECT_BORDER  - Selection box border (#RRGGBB)
#    COLOR_SCROLLBAR      - Scrollbar thumb color (#RRGGBB)
#    COLOR_DESKTOP        - Desktop fallback color (#RRGGBB)
#    MENU_LEFT            - Menu left position (e.g. "57%")
#    MENU_TOP             - Menu top position (e.g. "22%")
#    MENU_WIDTH           - Menu width (e.g. "38%")
#    MENU_HEIGHT          - Menu height (e.g. "52%")
#    TITLE_LEFT           - Title left position (e.g. "57%")
#    TITLE_TOP            - Title top position (e.g. "12%")
#    TITLE_WIDTH          - Title width (e.g. "38%")
# ============================================================================

install_theme() {
    local BG_SOURCE="${BACKGROUNDS_DIR}/${BG_FILE}"

    echo ""
    echo "╔══════════════════════════════════════════════╗"
    echo "║   ★  Star Wars GRUB2 Theme Installer  ★     ║"
    echo "║   Author: Futhark1393                        ║"
    echo "╚══════════════════════════════════════════════╝"
    echo ""

    # ── Root check ──────────────────────────────────────────────────────
    if [[ $EUID -ne 0 ]]; then
        echo "[ERROR] This script must be run as root (sudo)."
        exit 1
    fi

    # ── Background image check ──────────────────────────────────────────
    if [[ ! -f "${BG_SOURCE}" ]]; then
        echo "[ERROR] Background image not found: ${BG_SOURCE}"
        echo "        Make sure the backgrounds/ directory contains ${BG_FILE}"
        exit 1
    fi

    echo "[INFO] Theme          : ${THEME_TITLE}"
    echo "[INFO] Background     : ${BG_FILE}"
    echo "[INFO] Theme directory: ${THEME_DIR}"
    echo ""

    # ── Step 1: Dependencies ────────────────────────────────────────────
    echo "[STEP 1/7] Checking dependencies..."

    if ! command -v grub2-mkfont &>/dev/null; then
        echo "  → Installing grub2-tools..."
        dnf install -y grub2-tools 2>/dev/null || yum install -y grub2-tools 2>/dev/null || true
    fi

    MAGICK_CMD=""
    if command -v magick &>/dev/null; then
        MAGICK_CMD="magick"
    elif command -v convert &>/dev/null; then
        MAGICK_CMD="convert"
    else
        echo "  → Installing ImageMagick..."
        dnf install -y ImageMagick 2>/dev/null || yum install -y ImageMagick 2>/dev/null || true
        if command -v magick &>/dev/null; then
            MAGICK_CMD="magick"
        elif command -v convert &>/dev/null; then
            MAGICK_CMD="convert"
        fi
    fi

    if [[ -z "${MAGICK_CMD}" ]]; then
        echo "[ERROR] ImageMagick (convert/magick) not found."
        exit 1
    fi

    echo "  → ImageMagick: ${MAGICK_CMD}"

    # Find DejaVu Sans TTF
    FONT_TTF=""
    local FONT_SEARCH_PATHS=(
        "/usr/share/fonts/dejavu-sans-fonts/DejaVuSans.ttf"
        "/usr/share/fonts/dejavu/DejaVuSans.ttf"
        "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
        "/usr/share/fonts/TTF/DejaVuSans.ttf"
        "/usr/share/fonts/dejavu-sans/DejaVuSans.ttf"
    )

    for path in "${FONT_SEARCH_PATHS[@]}"; do
        if [[ -f "${path}" ]]; then
            FONT_TTF="${path}"
            break
        fi
    done

    if [[ -z "${FONT_TTF}" ]]; then
        echo "  → DejaVu Sans not found, installing..."
        dnf install -y dejavu-sans-fonts 2>/dev/null || yum install -y dejavu-sans-fonts 2>/dev/null || true
        for path in "${FONT_SEARCH_PATHS[@]}"; do
            if [[ -f "${path}" ]]; then
                FONT_TTF="${path}"
                break
            fi
        done
    fi

    if [[ -z "${FONT_TTF}" ]]; then
        FONT_TTF="$(find /usr/share/fonts -name 'DejaVuSans.ttf' -print -quit 2>/dev/null || true)"
    fi

    if [[ -z "${FONT_TTF}" ]]; then
        echo "[ERROR] Could not locate DejaVuSans.ttf."
        exit 1
    fi

    echo "  → Font: ${FONT_TTF}"
    echo "[OK] Dependencies satisfied."
    echo ""

    # ── Step 2: Create theme directory ──────────────────────────────────
    echo "[STEP 2/7] Creating theme directory..."

    if [[ -d "${THEME_DIR}" ]]; then
        echo "  → Removing previous installation..."
        rm -rf "${THEME_DIR}"
    fi

    mkdir -p "${THEME_DIR}"
    echo "[OK] ${THEME_DIR} created."
    echo ""

    # ── Step 3: Generate PF2 fonts ──────────────────────────────────────
    echo "[STEP 3/7] Generating GRUB2 bitmap fonts (.pf2)..."

    grub2-mkfont -s ${FONT_SIZE_MENU}  -o "${THEME_DIR}/${FONT_NAME}_${FONT_SIZE_MENU}.pf2"  "${FONT_TTF}"
    grub2-mkfont -s ${FONT_SIZE_TITLE} -o "${THEME_DIR}/${FONT_NAME}_${FONT_SIZE_TITLE}.pf2" "${FONT_TTF}"
    grub2-mkfont -s ${FONT_SIZE_SMALL} -o "${THEME_DIR}/${FONT_NAME}_${FONT_SIZE_SMALL}.pf2" "${FONT_TTF}"

    echo "[OK] Fonts generated."
    echo ""

    # ── Step 4: Process background image ────────────────────────────────
    echo "[STEP 4/7] Processing background image..."

    echo "  → Converting to 24-bit RGB PNG (no alpha) for GRUB2..."
    ${MAGICK_CMD} "${BG_SOURCE}" -type TrueColor -depth 8 -alpha off PNG24:"${THEME_DIR}/background.png"

    if [[ ! -s "${THEME_DIR}/background.png" ]]; then
        echo "[ERROR] Background image conversion failed."
        exit 1
    fi

    echo "[OK] Background saved ($(du -h "${THEME_DIR}/background.png" | cut -f1))"
    echo ""

    # ── Step 5: Generate selection pixmaps ──────────────────────────────
    echo "[STEP 5/7] Generating selection highlight pixmaps..."

    local BORDER_SIZE=3

    # Center fill
    ${MAGICK_CMD} -size 1x1 "xc:${COLOR_SELECT_BG}" -depth 8 PNG24:"${THEME_DIR}/select_c.png"

    # Border edges
    ${MAGICK_CMD} -size ${BORDER_SIZE}x1 "xc:${COLOR_SELECT_BORDER}" -depth 8 PNG24:"${THEME_DIR}/select_w.png"
    ${MAGICK_CMD} -size ${BORDER_SIZE}x1 "xc:${COLOR_SELECT_BORDER}" -depth 8 PNG24:"${THEME_DIR}/select_e.png"
    ${MAGICK_CMD} -size 1x${BORDER_SIZE} "xc:${COLOR_SELECT_BORDER}" -depth 8 PNG24:"${THEME_DIR}/select_n.png"
    ${MAGICK_CMD} -size 1x${BORDER_SIZE} "xc:${COLOR_SELECT_BORDER}" -depth 8 PNG24:"${THEME_DIR}/select_s.png"

    # Corners
    ${MAGICK_CMD} -size ${BORDER_SIZE}x${BORDER_SIZE} "xc:${COLOR_SELECT_BORDER}" -depth 8 PNG24:"${THEME_DIR}/select_nw.png"
    ${MAGICK_CMD} -size ${BORDER_SIZE}x${BORDER_SIZE} "xc:${COLOR_SELECT_BORDER}" -depth 8 PNG24:"${THEME_DIR}/select_ne.png"
    ${MAGICK_CMD} -size ${BORDER_SIZE}x${BORDER_SIZE} "xc:${COLOR_SELECT_BORDER}" -depth 8 PNG24:"${THEME_DIR}/select_sw.png"
    ${MAGICK_CMD} -size ${BORDER_SIZE}x${BORDER_SIZE} "xc:${COLOR_SELECT_BORDER}" -depth 8 PNG24:"${THEME_DIR}/select_se.png"

    # Scrollbar thumb
    ${MAGICK_CMD} -size 16x16 "xc:${COLOR_SCROLLBAR}" -depth 8 PNG24:"${THEME_DIR}/scrollbar_thumb.png"

    echo "[OK] Pixmaps generated (all opaque, 24-bit RGB)."
    echo ""

    # ── Step 6: Write theme.txt ──────────────────────────────────────────
    echo "[STEP 6/7] Writing theme.txt..."

    cat > "${THEME_DIR}/theme.txt" <<THEMEEOF
# ============================================================================
#  GRUB2 Theme: Star Wars — ${THEME_TITLE}
#  Author: Futhark1393
#  Background: ${BG_FILE}
# ============================================================================

# -- Global Properties -------------------------------------------------------

title-text: ""
desktop-image: "background.png"
desktop-color: "${COLOR_DESKTOP}"
terminal-font: "${FONT_NAME}_${FONT_SIZE_SMALL}.pf2"
terminal-left: "0"
terminal-top: "0"
terminal-width: "100%"
terminal-height: "100%"

# -- Title Label -------------------------------------------------------------

+ label {
    id = "__title__"
    text = "${THEME_TITLE}"
    font = "${FONT_NAME}_${FONT_SIZE_TITLE}.pf2"
    color = "${COLOR_TITLE}"
    align = "center"
    left = ${TITLE_LEFT}
    top = ${TITLE_TOP}
    width = ${TITLE_WIDTH}
}

# -- Boot Menu ---------------------------------------------------------------

+ boot_menu {
    left = ${MENU_LEFT}
    top = ${MENU_TOP}
    width = ${MENU_WIDTH}
    height = ${MENU_HEIGHT}
    item_height = 36
    item_padding = 8
    item_spacing = 4
    item_font = "${FONT_NAME}_${FONT_SIZE_MENU}.pf2"
    item_color = "${COLOR_ITEM}"
    selected_item_color = "${COLOR_ITEM_SELECTED}"
    selected_item_pixmap_style = "select_*.png"
    scrollbar = "true"
    scrollbar_width = 16
    scrollbar_thumb = "scrollbar_thumb.png"
}

# -- Countdown / Timer -------------------------------------------------------

+ label {
    id = "__timeout__"
    text = "Booting in %d seconds..."
    font = "${FONT_NAME}_${FONT_SIZE_SMALL}.pf2"
    color = "${COLOR_TIMER}"
    align = "center"
    left = ${MENU_LEFT}
    top = 76%
    width = ${MENU_WIDTH}
}

# -- Footer Keyboard Shortcuts -----------------------------------------------

+ label {
    id = "__info__"
    text = "Enter: Boot Selected  |  e: Edit Entry  |  c: Command Line"
    font = "${FONT_NAME}_${FONT_SIZE_SMALL}.pf2"
    color = "${COLOR_INFO}"
    align = "center"
    left = 20%
    top = 90%
    width = 60%
}

+ label {
    id = "__nav__"
    text = "Use arrow keys to navigate"
    font = "${FONT_NAME}_${FONT_SIZE_SMALL}.pf2"
    color = "${COLOR_INFO}"
    align = "center"
    left = 20%
    top = 94%
    width = 60%
}
THEMEEOF

    echo "[OK] theme.txt written."
    echo ""

    # ── Step 7: Configure GRUB & regenerate ──────────────────────────────
    echo "[STEP 7/7] Configuring GRUB2..."

    # Backup
    if [[ -f "${GRUB_DEFAULT_FILE}" ]]; then
        local BACKUP_FILE="${GRUB_DEFAULT_FILE}.bak.$(date +%Y%m%d%H%M%S)"
        cp "${GRUB_DEFAULT_FILE}" "${BACKUP_FILE}"
        echo "  → Backed up ${GRUB_DEFAULT_FILE}"
    fi

    # Remove existing theme lines
    sed -i '/^GRUB_THEME=/d' "${GRUB_DEFAULT_FILE}"
    sed -i '/^GRUB_TERMINAL_OUTPUT=/d' "${GRUB_DEFAULT_FILE}"

    # Add new theme config
    {
        echo ""
        echo "# Star Wars GRUB2 Theme (Futhark1393)"
        echo "GRUB_THEME=\"${THEME_DIR}/theme.txt\""
        echo "GRUB_TERMINAL_OUTPUT=\"gfxterm\""
    } >> "${GRUB_DEFAULT_FILE}"

    echo "  → GRUB_THEME set in ${GRUB_DEFAULT_FILE}"

    # Ensure GRUB_GFXMODE
    if ! grep -q '^GRUB_GFXMODE=' "${GRUB_DEFAULT_FILE}"; then
        echo 'GRUB_GFXMODE="auto"' >> "${GRUB_DEFAULT_FILE}"
        echo "  → Added GRUB_GFXMODE=auto"
    fi

    # Regenerate GRUB2 config
    echo "  → Running grub2-mkconfig..."
    grub2-mkconfig -o "${GRUB_CFG}" 2>&1

    echo ""
    echo "╔══════════════════════════════════════════════╗"
    echo "║   ✓ Theme installed successfully!            ║"
    echo "║                                              ║"
    echo "║   Theme : ${THEME_TITLE}"
    echo "║   Path  : ${THEME_DIR}"
    echo "║                                              ║"
    echo "║   Reboot to see your new GRUB theme!         ║"
    echo "╚══════════════════════════════════════════════╝"
    echo ""
}

# ============================================================================
#  uninstall_theme()  —  Remove theme and restore GRUB defaults
# ============================================================================

uninstall_theme() {
    echo ""
    echo "╔══════════════════════════════════════════════╗"
    echo "║   Star Wars GRUB2 Theme — Uninstaller        ║"
    echo "╚══════════════════════════════════════════════╝"
    echo ""

    if [[ $EUID -ne 0 ]]; then
        echo "[ERROR] This script must be run as root (sudo)."
        exit 1
    fi

    if [[ -d "${THEME_DIR}" ]]; then
        rm -rf "${THEME_DIR}"
        echo "[OK] Theme directory removed: ${THEME_DIR}"
    else
        echo "[INFO] Theme directory not found (already removed?)."
    fi

    # Remove theme lines from GRUB config
    sed -i '/^GRUB_THEME=/d' "${GRUB_DEFAULT_FILE}"
    sed -i '/^# Star Wars GRUB2 Theme/d' "${GRUB_DEFAULT_FILE}"

    # Regenerate GRUB2 config
    echo "  → Regenerating GRUB2 config..."
    grub2-mkconfig -o "${GRUB_CFG}" 2>&1

    echo ""
    echo "[OK] Theme uninstalled. Reboot to see default GRUB."
    echo ""
}
