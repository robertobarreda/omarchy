#!/bin/bash

ansi_save_cursor() { printf "\033[s"; }
ansi_restore_cursor() { printf "\033[u"; }
ansi_clear_line() { printf "\033[2K"; }
ansi_clear_below() { printf "\033[J"; }
ansi_move_up() { printf "\033[${1}A"; }
ansi_move_down() { printf "\033[${1}B"; }
ansi_move_to_column() { printf "\033[${1}G"; }
ansi_hide_cursor() { printf "\033[?25l"; }
ansi_show_cursor() { printf "\033[?25h"; }
ansi_clear_screen() { printf "\033[H\033[2J"; }
ansi_move_to() { printf "\033[${1};${2}H"; } # row, column
