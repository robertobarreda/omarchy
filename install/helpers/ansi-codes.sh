#!/bin/bash

# ANSI escape sequence variables for direct use
ANSI_SAVE_CURSOR="\033[s"
ANSI_RESTORE_CURSOR="\033[u"
ANSI_CLEAR_LINE="\033[2K"
ANSI_CLEAR_BELOW="\033[J"
ANSI_HIDE_CURSOR="\033[?25l"
ANSI_SHOW_CURSOR="\033[?25h"
ANSI_CLEAR_SCREEN="\033[H\033[2J"
ANSI_RESET="\033[0m"

# ANSI color codes
ANSI_GRAY="\033[90m"
ANSI_RED="\033[31m"
ANSI_GREEN="\033[32m"
ANSI_YELLOW="\033[33m"
ANSI_BLUE="\033[34m"
ANSI_MAGENTA="\033[35m"
ANSI_CYAN="\033[36m"

# Functions for backwards compatibility and dynamic values
ansi_save_cursor() { printf "${ANSI_SAVE_CURSOR}"; }
ansi_restore_cursor() { printf "${ANSI_RESTORE_CURSOR}"; }
ansi_clear_line() { printf "${ANSI_CLEAR_LINE}"; }
ansi_clear_below() { printf "${ANSI_CLEAR_BELOW}"; }
ansi_move_up() { printf "\033[${1}A"; }
ansi_move_down() { printf "\033[${1}B"; }
ansi_move_to_column() { printf "\033[${1}G"; }
ansi_hide_cursor() { printf "${ANSI_HIDE_CURSOR}"; }
ansi_show_cursor() { printf "${ANSI_SHOW_CURSOR}"; }
ansi_clear_screen() { printf "${ANSI_CLEAR_SCREEN}"; }
ansi_move_to() { printf "\033[${1};${2}H"; } # row, column
