#!/usr/bin/env bash
# Theme 12: Mustafar Duel — Obi-Wan vs Anakin on lava planet, intense red/orange
# Composition: Lava eruption center-left, duelists upper-right on cliff, red everywhere
# Best area: Upper-left (smoky dark area above lava)

THEME_TITLE="You Were The Chosen One"
BG_FILE="background12.png"

COLOR_ITEM="#E8A060"
COLOR_ITEM_SELECTED="#FFD700"
COLOR_TITLE="#FFC060"
COLOR_TIMER="#AA5020"
COLOR_INFO="#883818"
COLOR_SELECT_BG="#2A0808"
COLOR_SELECT_BORDER="#882010"
COLOR_SCROLLBAR="#FF6020"
COLOR_DESKTOP="#180404"

MENU_LEFT="3%"
MENU_TOP="5%"
MENU_WIDTH="38%"
MENU_HEIGHT="50%"
TITLE_LEFT="3%"
TITLE_TOP="1%"
TITLE_WIDTH="38%"

source "$(dirname "$0")/theme-engine.sh"
install_theme
