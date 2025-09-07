#!/bin/bash

QR_CODE='
█▀▀▀▀▀█ ▄ ▄ ▀▄▄▄█ █▀▀▀▀▀█
█ ███ █ ▄▄▄▄▀▄▀▄▀ █ ███ █
█ ▀▀▀ █ ▄█  ▄█▄▄▀ █ ▀▀▀ █
▀▀▀▀▀▀▀ ▀▄█ █ █ █ ▀▀▀▀▀▀▀
▀▀█▀▀▄▀▀▀▀▄█▀▀█  ▀ █ ▀ █ 
█▄█ ▄▄▀▄▄ ▀ ▄ ▀█▄▄▄▄ ▀ ▀█
▄ ▄▀█ ▀▄▀▀▀▄ ▄█▀▄█▀▄▀▄▀█▀
█ ▄▄█▄▀▄█ ▄▄▄  ▀ ▄▀██▀ ▀█
▀ ▀   ▀ █ ▀▄  ▀▀█▀▀▀█▄▀  
█▀▀▀▀▀█ ▀█  ▄▀▀ █ ▀ █▄▀██
█ ███ █ █▀▄▄▀ █▀███▀█▄██▄
█ ▀▀▀ █ ██  ▀ █▄█ ▄▄▄█▀ █
▀▀▀▀▀▀▀ ▀ ▀ ▀▀▀  ▀ ▀▀▀▀▀▀'

# Cleanup function - always stop monitoring and restore cursor
cleanup() {
  # Stop log monitoring if running
  if [ -n "${monitor_pid:-}" ]; then
    kill $monitor_pid 2>/dev/null || true
    unset monitor_pid
  fi

  # Clear log area and restore cursor
  ansi_restore_cursor
  ansi_move_up 2 # Move up to replace "Installing Omarchy..." line
  ansi_clear_below
  ansi_show_cursor
}

# Error handler
catch_errors() {
  cleanup

  gum style --foreground 1 --padding "1 0 1 $PADDING_DISTANCE" "Omarchy installation failed!"

  LOG_LINES=$(($TERM_HEIGHT - $LOGO_HEIGHT - 35))

  # Show the last lines of the log to help debug
  if [ -n "${LOG_FILE:-}" ] && [ -f "$LOG_FILE" ]; then
    max_line_width=$((LOGO_WIDTH - 4))
    tail -n $LOG_LINES "$LOG_FILE" | while IFS= read -r line; do
      if [ ${#line} -gt $max_line_width ]; then
        truncated_line="${line:0:$max_line_width}..."
      else
        truncated_line="$line"
      fi
      echo "${PADDING}$truncated_line"
    done
    echo
  fi

  echo "${PADDING}This command halted with exit code $?:"
  echo "${PADDING}$BASH_COMMAND"
  gum style --padding "0 0 0 $PADDING_DISTANCE" "$QR_CODE"
  echo
  echo "${PADDING}Get help from the community via QR code or at https://discord.gg/tXFUdasqhY"

  # Offer options menu
  if command -v gum >/dev/null; then
    while true; do
      # Build menu options
      options=()

      # If not offline install, show retry first
      if [ -z "$OMARCHY_OFFLINE_INSTALL" ]; then
        options+=("Retry installation")
      fi

      # Add upload option if internet is available
      if ping -c 1 -W 1 1.1.1.1 >/dev/null 2>&1; then
        options+=("Upload log for support")
      fi

      # Add remaining options
      options+=("View full log")
      
      # Add retry at the end if offline install
      if [ -n "$OMARCHY_OFFLINE_INSTALL" ]; then
        options+=("Retry installation")
      fi
      
      options+=("Exit")

      choice=$(gum choose "${options[@]}" --header "What would you like to do?" --height 6 --padding "1 $PADDING_DISTANCE")

      case "$choice" in
      "Retry installation")
        bash ~/.local/share/omarchy/install.sh
        break
        ;;
      "View full log")
        less "$LOG_FILE"
        ;;
      "Upload log for support")
        omarchy-upload-install-log
        ;;
      "Exit" | "")
        echo "You can retry later by running: bash ~/.local/share/omarchy/install.sh"
        break
        ;;
      esac
    done
  else
    echo "You can retry later by running: bash ~/.local/share/omarchy/install.sh"
  fi
}

# Interrupt handler
interrupt() {
  cleanup

  gum style --foreground 1 --padding "1 0 1 $PADDING_DISTANCE" "Omarchy installation interrupted!"
}

# Set up traps
trap catch_errors ERR
trap interrupt INT TERM
