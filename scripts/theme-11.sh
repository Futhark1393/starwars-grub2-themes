#!/usr/bin/env bash
# Theme 11: Death Star Classic — Monochrome/grey Death Star on right, vast empty black space left
# Composition: Death Star occupies right 40%, pure black starfield left 60%
# Best area: Left half (lots of empty dark space)

THEME_TITLE="Ultimate Power"
BG_FILE="background11.png"

COLOR_ITEM="#808890"
COLOR_ITEM_SELECTED="#C0C8D0"
COLOR_TITLE="#A0A8B0"
COLOR_TIMER="#505860"
COLOR_INFO="#404850"
COLOR_SELECT_BG="#0A0A0C"
COLOR_SELECT_BORDER="#303840"
COLOR_SCROLLBAR="#707880"
COLOR_DESKTOP="#000000"

MENU_LEFT="5%"
MENU_TOP="18%"
MENU_WIDTH="40%"
MENU_HEIGHT="52%"
TITLE_LEFT="5%"
TITLE_TOP="8%"
TITLE_WIDTH="40%"

source "$(dirname "$0")/theme-engine.sh"
install_theme
