# Create the log file with proper permissions
sudo touch "$LOG_FILE"
sudo chmod 666 "$LOG_FILE"

# Start logging
export OMARCHY_START_TIME=$(date '+%Y-%m-%d %H:%M:%S')
echo "=== Omarchy Installation Started: $OMARCHY_START_TIME ===" >>"$LOG_FILE"
