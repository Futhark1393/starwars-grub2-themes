#!/usr/bin/env bash
# Theme 05: Cloud City Battle — Millennium Falcon, X-wings over Bespin
# Composition: Cloud City structure upper-left, Falcon center-bottom, action everywhere
# Best area: Lower-left (below cloud city, some open cloud space)

THEME_TITLE="Battle of Bespin"
BG_FILE="background5.png"

COLOR_ITEM="#F0E0C0"
COLOR_ITEM_SELECTED="#FFD700"
COLOR_TITLE="#FFF0D0"
COLOR_TIMER="#C0A060"
COLOR_INFO="#A08848"
COLOR_SELECT_BG="#302010"
COLOR_SELECT_BORDER="#A08030"
COLOR_SCROLLBAR="#D4A017"
COLOR_DESKTOP="#1A1005"

MENU_LEFT="3%"
MENU_TOP="20%"
MENU_WIDTH="32%"
MENU_HEIGHT="50%"
TITLE_LEFT="3%"
TITLE_TOP="10%"
TITLE_WIDTH="32%"

source "$(dirname "$0")/theme-engine.sh"
install_theme
