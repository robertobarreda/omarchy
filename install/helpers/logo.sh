clear_logo() {
  # Clear screen and move cursor to top-left
  printf "\033[H\033[2J"

  gum style --foreground 2 --padding "1 0 0 $PADDING_LEFT" "$(<"$LOGO_PATH")"
}
