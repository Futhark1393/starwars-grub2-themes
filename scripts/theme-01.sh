#!/usr/bin/env bash
# Theme 01: Tatooine Sunset — Cloaked figure watching twin suns
# Composition: Figure on left rocks (0-35%), twin suns center-right (60-72%)
# Best area: Upper-right sky quadrant

THEME_TITLE="Choose Your Path"
BG_FILE="background1.png"

COLOR_ITEM="#E8C896"
COLOR_ITEM_SELECTED="#FFD700"
COLOR_TITLE="#FFF5CC"
COLOR_TIMER="#CC8855"
COLOR_INFO="#996644"
COLOR_SELECT_BG="#3D0C0C"
COLOR_SELECT_BORDER="#A04010"
COLOR_SCROLLBAR="#D4A017"
COLOR_DESKTOP="#1A0A05"

MENU_LEFT="57%"
MENU_TOP="22%"
MENU_WIDTH="38%"
MENU_HEIGHT="52%"
TITLE_LEFT="57%"
TITLE_TOP="12%"
TITLE_WIDTH="38%"

source "$(dirname "$0")/theme-engine.sh"
install_theme
