#!/usr/bin/env bash
# Theme 07: Darth Vader Portrait — Vader profile on right, blue/dark atmosphere
# Composition: Vader takes up right 40%, blurry blue-grey space on left
# Best area: Left half (blue misty background)

THEME_TITLE="The Dark Side"
BG_FILE="background7.png"

COLOR_ITEM="#8899BB"
COLOR_ITEM_SELECTED="#CC3333"
COLOR_TITLE="#A0B0D0"
COLOR_TIMER="#556688"
COLOR_INFO="#445577"
COLOR_SELECT_BG="#0A0E18"
COLOR_SELECT_BORDER="#334466"
COLOR_SCROLLBAR="#CC3333"
COLOR_DESKTOP="#050810"

MENU_LEFT="5%"
MENU_TOP="18%"
MENU_WIDTH="40%"
MENU_HEIGHT="52%"
TITLE_LEFT="5%"
TITLE_TOP="8%"
TITLE_WIDTH="40%"

source "$(dirname "$0")/theme-engine.sh"
install_theme
