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
  stop_log_output
  ansi_show_cursor
}

# Track if we're already handling an error to prevent double-trapping
ERROR_HANDLING=false

# Error handler
catch_errors() {
  # Store exit code immediately before it gets overwritten
  local exit_code=$?

  # Prevent recursive error handling
  if [ "$ERROR_HANDLING" = "true" ]; then
    return
  fi
  ERROR_HANDLING=true

  local error_type="${1:-failed}"
  cleanup

  # Restore stdout and stderr to original (saved in FD 3 and 4)
  # This ensures output goes to screen, not log file
  if [ -e /proc/self/fd/3 ] && [ -e /proc/self/fd/4 ]; then
    exec 1>&3 2>&4
  fi

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

  gum style "This command halted with exit code $exit_code:"

  # Show the failed script if available, otherwise show the command
  if [ -n "${CURRENT_SCRIPT:-}" ]; then
    gum style "Failed script: $CURRENT_SCRIPT"
  else
    # Truncate long command lines to fit the display
    local cmd="$BASH_COMMAND"
    local max_cmd_width=$((LOGO_WIDTH - 4))
    if [ ${#cmd} -gt $max_cmd_width ]; then
      cmd="${cmd:0:$max_cmd_width}..."
    fi
    gum style "$cmd"
  fi
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

# Exit handler - ensures cleanup happens on any exit
exit_handler() {
  local exit_code=$?

  # Only run if we're exiting with an error and haven't already handled it
  if [ $exit_code -ne 0 ] && [ "$ERROR_HANDLING" != "true" ]; then
    catch_errors
  else
    # Still need to clean up even on successful exit
    cleanup
  fi
}

# Set up traps
trap catch_errors ERR
trap exit_handler EXIT
trap interrupt INT TERM
