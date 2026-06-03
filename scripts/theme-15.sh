#!/usr/bin/env bash
# Theme 15: Master Yoda — Yoda close-up on Dagobah, center-right, dark swamp forest
# Composition: Yoda takes up center-right (40-90%), dark misty swamp left
# Best area: Left side (dark swamp mist)

THEME_TITLE="Do or Do Not"
BG_FILE="background15.png"

COLOR_ITEM="#8AA070"
COLOR_ITEM_SELECTED="#C0E060"
COLOR_TITLE="#A0C080"
COLOR_TIMER="#607050"
COLOR_INFO="#506040"
COLOR_SELECT_BG="#0A1008"
COLOR_SELECT_BORDER="#304020"
COLOR_SCROLLBAR="#88B048"
COLOR_DESKTOP="#060A04"

MENU_LEFT="3%"
MENU_TOP="15%"
MENU_WIDTH="35%"
MENU_HEIGHT="52%"
TITLE_LEFT="3%"
TITLE_TOP="5%"
TITLE_WIDTH="35%"

source "$(dirname "$0")/theme-engine.sh"
install_theme
