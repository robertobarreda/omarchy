#!/bin/bash

# Function to start log output monitoring
start_log_output() {
  # Save cursor position for log output
  ansi_save_cursor

  # Hide cursor for cleaner display
  ansi_hide_cursor

  # Start background process to monitor log
  (
    log_lines=20
    max_line_width=$((LOGO_WIDTH - 4))
    while true; do
      # Go back to saved position
      ansi_restore_cursor

      # Display last N lines from log
      tail -n $log_lines "$LOG_FILE" 2>/dev/null | while IFS= read -r line; do
        ansi_clear_line
        if [ ${#line} -gt $max_line_width ]; then
          truncated_line="${line:0:$max_line_width}..."
        else
          truncated_line="$line"
        fi
        printf "\033[90m${PADDING}  → %s\033[0m\n" "$truncated_line"
      done

      # Clear remaining lines if fewer than log_lines
      shown=$(tail -n $log_lines "$LOG_FILE" 2>/dev/null | wc -l)
      for ((i = shown; i < log_lines; i++)); do
        ansi_clear_line
        echo
      done

      sleep 0.1
    done
  ) &
  monitor_pid=$!
}