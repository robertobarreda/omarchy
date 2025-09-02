# Create the log file with proper permissions
sudo touch "$LOG_FILE"
sudo chmod 666 "$LOG_FILE"

# Start logging
export OMARCHY_START_TIME=$(date '+%Y-%m-%d %H:%M:%S')
echo "=== Omarchy Installation Started: $OMARCHY_START_TIME ===" >> "$LOG_FILE"

# Log installation mode
if [ -n "$OMARCHY_CHROOT_INSTALL" ]; then
  echo "Installation mode: CHROOT" >>"$LOG_FILE"
else
  echo "Installation mode: NORMAL" >>"$LOG_FILE"
fi

if [ -n "$OMARCHY_OFFLINE_INSTALL" ]; then
  echo "Offline install: YES" >>"$LOG_FILE"
else
  echo "Offline install: NO" >>"$LOG_FILE"
fi

# Don't use exec redirection here - it conflicts with gum spin
# The run() function will handle logging to $LOG_FILE
