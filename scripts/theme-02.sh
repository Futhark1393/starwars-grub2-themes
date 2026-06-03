#!/usr/bin/env bash
# Theme 02: A New Hope Poster — Classic poster art, characters on right side
# Composition: Vader helmet top-right, Luke/Leia center-right, Death Stars
# Best area: Upper-left starfield

THEME_TITLE="A New Hope"
BG_FILE="background2.png"

COLOR_ITEM="#C8D8F0"
COLOR_ITEM_SELECTED="#FFD700"
COLOR_TITLE="#E8D090"
COLOR_TIMER="#6688AA"
COLOR_INFO="#5577AA"
COLOR_SELECT_BG="#0A1628"
COLOR_SELECT_BORDER="#2244AA"
COLOR_SCROLLBAR="#FFD700"
COLOR_DESKTOP="#050A14"

MENU_LEFT="3%"
MENU_TOP="18%"
MENU_WIDTH="38%"
MENU_HEIGHT="52%"
TITLE_LEFT="3%"
TITLE_TOP="8%"
TITLE_WIDTH="38%"

source "$(dirname "$0")/theme-engine.sh"
install_theme
