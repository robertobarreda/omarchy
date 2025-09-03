if [ -n "${LOG_FILE:-}" ]; then
  OMARCHY_END_TIME=$(date '+%Y-%m-%d %H:%M:%S')
  echo "=== Omarchy Installation Completed: $OMARCHY_END_TIME ===" >> "$LOG_FILE"

  if [ -f "/var/log/archinstall/install.log" ]; then
    echo "" >> "$LOG_FILE"
    echo "=== Installation Time Summary ===" >> "$LOG_FILE"

    ARCHINSTALL_START=$(grep -m1 '^\[' /var/log/archinstall/install.log 2>/dev/null | sed 's/^\[\([^]]*\)\].*/\1/' || true)
    ARCHINSTALL_END=$(grep 'Installation completed without any errors' /var/log/archinstall/install.log 2>/dev/null | sed 's/^\[\([^]]*\)\].*/\1/' || true)

    if [ -n "$ARCHINSTALL_START" ] && [ -n "$ARCHINSTALL_END" ]; then
      ARCH_START_EPOCH=$(date -d "$ARCHINSTALL_START" +%s)
      ARCH_END_EPOCH=$(date -d "$ARCHINSTALL_END" +%s)
      ARCH_DURATION=$((ARCH_END_EPOCH - ARCH_START_EPOCH))

      ARCH_MINS=$((ARCH_DURATION / 60))
      ARCH_SECS=$((ARCH_DURATION % 60))

      echo "Archinstall: ${ARCH_MINS}m ${ARCH_SECS}s" >> "$LOG_FILE"
    fi

    if [ -n "$OMARCHY_START_TIME" ]; then
      OMARCHY_START_EPOCH=$(date -d "$OMARCHY_START_TIME" +%s)
      OMARCHY_END_EPOCH=$(date -d "$OMARCHY_END_TIME" +%s)
      OMARCHY_DURATION=$((OMARCHY_END_EPOCH - OMARCHY_START_EPOCH))

      OMARCHY_MINS=$((OMARCHY_DURATION / 60))
      OMARCHY_SECS=$((OMARCHY_DURATION % 60))

      echo "Omarchy:     ${OMARCHY_MINS}m ${OMARCHY_SECS}s" >> "$LOG_FILE"

      if [ -n "$ARCH_DURATION" ]; then
        TOTAL_DURATION=$((ARCH_DURATION + OMARCHY_DURATION))
        TOTAL_MINS=$((TOTAL_DURATION / 60))
        TOTAL_SECS=$((TOTAL_DURATION % 60))
        echo "Total:       ${TOTAL_MINS}m ${TOTAL_SECS}s" >> "$LOG_FILE"
      fi
    fi
    echo "=================================" >> "$LOG_FILE"
  fi

  echo "Rebooting system..." >> "$LOG_FILE"
fi
