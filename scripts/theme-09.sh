#!/usr/bin/env bash
# Theme 09: X-Wing Squadron — X-wings flying at sunset (painted art style)
# Composition: Lead X-wing center-left, smaller ones center-right, sunset clouds
# Best area: Lower-right dark area

THEME_TITLE="Red Squadron"
BG_FILE="background9.png"

COLOR_ITEM="#D8C8A0"
COLOR_ITEM_SELECTED="#FFD060"
COLOR_TITLE="#F0E0B0"
COLOR_TIMER="#907850"
COLOR_INFO="#786840"
COLOR_SELECT_BG="#1A1408"
COLOR_SELECT_BORDER="#705828"
COLOR_SCROLLBAR="#D4A030"
COLOR_DESKTOP="#0A0805"

MENU_LEFT="60%"
MENU_TOP="20%"
MENU_WIDTH="36%"
MENU_HEIGHT="50%"
TITLE_LEFT="60%"
TITLE_TOP="10%"
TITLE_WIDTH="36%"

source "$(dirname "$0")/theme-engine.sh"
install_theme
