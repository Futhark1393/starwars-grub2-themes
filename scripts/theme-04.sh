#!/usr/bin/env bash
# Theme 04: Four Panels — Force Awakens art (blue forest, orange desert, green lake, red fire)
# Composition: Four vertical panels fill the entire image
# Best area: Center of image (overlay on the panels)

THEME_TITLE="The Force Awakens"
BG_FILE="background4.png"

COLOR_ITEM="#E0D8C8"
COLOR_ITEM_SELECTED="#FFD700"
COLOR_TITLE="#F5E8C0"
COLOR_TIMER="#A09080"
COLOR_INFO="#887868"
COLOR_SELECT_BG="#1A1410"
COLOR_SELECT_BORDER="#886830"
COLOR_SCROLLBAR="#D4A017"
COLOR_DESKTOP="#0A0806"

MENU_LEFT="32%"
MENU_TOP="20%"
MENU_WIDTH="36%"
MENU_HEIGHT="52%"
TITLE_LEFT="32%"
TITLE_TOP="10%"
TITLE_WIDTH="36%"

source "$(dirname "$0")/theme-engine.sh"
install_theme
