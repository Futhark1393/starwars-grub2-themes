#!/usr/bin/env bash
# Theme 14: Falcon Over Planet — Falcon center-top orbiting orange/red planet atmosphere
# Composition: Falcon center-upper, orange planet surface fills bottom half, black space top
# Best area: Upper-left corner (empty dark space)

THEME_TITLE="Orbital Approach"
BG_FILE="background14.png"

COLOR_ITEM="#D0A878"
COLOR_ITEM_SELECTED="#66CCFF"
COLOR_TITLE="#E0C090"
COLOR_TIMER="#886040"
COLOR_INFO="#704830"
COLOR_SELECT_BG="#100806"
COLOR_SELECT_BORDER="#604020"
COLOR_SCROLLBAR="#CC8840"
COLOR_DESKTOP="#000000"

MENU_LEFT="3%"
MENU_TOP="5%"
MENU_WIDTH="38%"
MENU_HEIGHT="48%"
TITLE_LEFT="3%"
TITLE_TOP="1%"
TITLE_WIDTH="38%"

source "$(dirname "$0")/theme-engine.sh"
install_theme
