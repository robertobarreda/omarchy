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

  ansi_show_cursor
}

# Error handler
catch_errors() {
  local error_type="${1:-failed}"
  cleanup

  clear_logo

  if [ "$error_type" = "interrupted" ]; then
    gum style --foreground 1 --padding "1 0 1 $PADDING_LEFT" "Omarchy installation interrupted!"
  else
    gum style --foreground 1 --padding "1 0 1 $PADDING_LEFT" "Omarchy installation failed!"
  fi

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
      gum style "$truncated_line"
    done
    echo
  fi

  gum style "This command halted with exit code $?:"
  gum style "$BASH_COMMAND"
  gum style "$QR_CODE"
  echo
  gum style "Get help from the community via QR code or at https://discord.gg/tXFUdasqhY"

  # Offer options menu
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

    choice=$(gum choose "${options[@]}" --header "What would you like to do?" --height 6 --padding "1 $PADDING_LEFT")

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
      gum style "You can retry later by running: bash ~/.local/share/omarchy/install.sh"
      exit 1
      ;;
    esac
  done
}

# Interrupt handler
interrupt() {
  catch_errors "interrupted"
}

# Set up traps
trap catch_errors ERR
trap interrupt INT TERM
