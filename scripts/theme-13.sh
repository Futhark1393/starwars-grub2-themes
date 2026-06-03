#!/usr/bin/env bash
# Theme 13: Millennium Falcon in Space — Falcon top-right, pure dark starfield, lots of empty space
# Composition: Falcon upper-right (25-75% right, 15-50% top), rest is dark starfield
# Best area: Left half (empty starfield)

THEME_TITLE="Punch It, Chewie!"
BG_FILE="background13.png"

COLOR_ITEM="#8899AA"
COLOR_ITEM_SELECTED="#66CCFF"
COLOR_TITLE="#AABBCC"
COLOR_TIMER="#556677"
COLOR_INFO="#445566"
COLOR_SELECT_BG="#060808"
COLOR_SELECT_BORDER="#223344"
COLOR_SCROLLBAR="#66AACC"
COLOR_DESKTOP="#000000"

MENU_LEFT="5%"
MENU_TOP="15%"
MENU_WIDTH="40%"
MENU_HEIGHT="55%"
TITLE_LEFT="5%"
TITLE_TOP="5%"
TITLE_WIDTH="40%"

source "$(dirname "$0")/theme-engine.sh"
install_theme
