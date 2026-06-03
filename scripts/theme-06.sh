#!/usr/bin/env bash
# Theme 06: Millennium Falcon Sunset — Falcon flying over desert with twin suns
# Composition: Falcon center-right, twin suns upper-left horizon, desert landscape
# Best area: Upper-left sky region (above the horizon glow)

THEME_TITLE="The Kessel Run"
BG_FILE="background6.png"

COLOR_ITEM="#D8C0A0"
COLOR_ITEM_SELECTED="#F0D080"
COLOR_TITLE="#FFE8C0"
COLOR_TIMER="#A08060"
COLOR_INFO="#886848"
COLOR_SELECT_BG="#1A1008"
COLOR_SELECT_BORDER="#806030"
COLOR_SCROLLBAR="#C4A040"
COLOR_DESKTOP="#0A0805"

MENU_LEFT="3%"
MENU_TOP="8%"
MENU_WIDTH="35%"
MENU_HEIGHT="50%"
TITLE_LEFT="3%"
TITLE_TOP="2%"
TITLE_WIDTH="35%"

source "$(dirname "$0")/theme-engine.sh"
install_theme
