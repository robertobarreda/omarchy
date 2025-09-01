# Set up logging if we're in a chroot install environment
if [ -n "$OMARCHY_CHROOT_INSTALL" ]; then
  LOG_FILE="/var/log/omarchy-install.log"

  # Create the log file with proper permissions
  sudo touch "$LOG_FILE"
  sudo chmod 666 "$LOG_FILE"

  # Start logging
  OMARCHY_START_TIME=$(date '+%Y-%m-%d %H:%M:%S')
  echo "=== Omarchy Installation Started: $OMARCHY_START_TIME ==="

  # Redirect all output to both console and log file
  exec 2>&1
  exec > >(tee -a "$LOG_FILE")
fi
