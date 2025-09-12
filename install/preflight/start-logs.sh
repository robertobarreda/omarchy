# Create the log file with proper permissions
sudo touch "$OMARCHY_INSTALL_LOG_FILE"
sudo chmod 666 "$OMARCHY_INSTALL_LOG_FILE"

# Start logging
export OMARCHY_START_TIME=$(date '+%Y-%m-%d %H:%M:%S')
echo "=== Omarchy Installation Started: $OMARCHY_START_TIME ===" >>"$OMARCHY_INSTALL_LOG_FILE"
