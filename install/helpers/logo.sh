clear_logo() {
  ansi_clear_screen

  gum style --foreground 2 --padding "1 0 0 $PADDING_DISTANCE" "$(<"$LOGO_PATH")"
}

export clear_logo
