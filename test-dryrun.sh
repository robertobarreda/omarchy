#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

OMARCHY_PATH="$HOME/Dev/omarchy"
OMARCHY_INSTALL="$OMARCHY_PATH/install"
LOG_FILE="/tmp/omarchy-dryrun.log"

if [ -z "$TERM_WIDTH" ]; then
  source "$OMARCHY_INSTALL/helpers/size.sh"
fi

#################################
# Helpers
#################################
source "$OMARCHY_INSTALL/helpers/ansi-codes.sh"
source "$OMARCHY_INSTALL/helpers/logo.sh"
source "$OMARCHY_INSTALL/helpers/gum-styling.sh"
source "$OMARCHY_INSTALL/preflight/trap-errors.sh"
source "$OMARCHY_INSTALL/helpers/tail-log-output.sh"

#################################
# Test / Dry-run ONLY functions
#################################
source "$OMARCHY_INSTALL/helpers/dry-run-helpers.sh"

#################################
# Installation sequence
#################################
source $OMARCHY_INSTALL/preflight/start-logs.sh

clear_logo

gum style --foreground 3 --padding "1 0 0 $PADDING_LEFT" "Installing Omarchy..."

start_log_output

run_logged() {
  source "$1" >>"$LOG_FILE" 2>&1
}

run_logged $OMARCHY_INSTALL/preflight/show-env.sh

# Run all installation phases
run_preparation
run_packaging
run_configuration
run_login
run_finishing

source $OMARCHY_INSTALL/post-install/stop-logs.sh
source $OMARCHY_INSTALL/reboot.sh
