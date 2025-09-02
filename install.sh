#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

OMARCHY_PATH="$HOME/.local/share/omarchy"
OMARCHY_INSTALL="$OMARCHY_PATH/install"
LOG_FILE="/var/log/omarchy-install.log"
export PATH="$OMARCHY_PATH/bin:$PATH"

run() {
  set -eEo pipefail
  local script_name=$(basename "$1")
  local start_time=$(date +%s)

  # Log everything silently (no tee to stdout)
  if [ -n "${LOG_FILE:-}" ]; then
    echo "Executing $script_name..." >>"$LOG_FILE"
    source "$1" >>"$LOG_FILE" 2>&1
    local exit_status=$?
  else
    echo "Executing $script_name..."
    source "$1"
    local exit_status=$?
  fi

  local end_time=$(date +%s)
  local duration=$((end_time - start_time))

  if [ -n "${LOG_FILE:-}" ]; then
    echo "Finished executing $script_name (took ${duration}s)" >>"$LOG_FILE"
  else
    echo "Finished executing $script_name (took ${duration}s)"
  fi

  # Propagate the exit status
  return $exit_status
}

# Group sections into functions
run_preparation() {
  set -eEo pipefail
  run $OMARCHY_INSTALL/preflight/show-env.sh
  run $OMARCHY_INSTALL/preflight/trap-errors.sh
  run $OMARCHY_INSTALL/preflight/guard.sh
  run $OMARCHY_INSTALL/preflight/pacman.sh
  run $OMARCHY_INSTALL/preflight/migrations.sh
  run $OMARCHY_INSTALL/preflight/first-run-mode.sh
}

run_packaging() {
  set -eEo pipefail
  run $OMARCHY_INSTALL/packages.sh
  run $OMARCHY_INSTALL/packaging/fonts.sh
  run $OMARCHY_INSTALL/packaging/lazyvim.sh
  run $OMARCHY_INSTALL/packaging/webapps.sh
  run $OMARCHY_INSTALL/packaging/tuis.sh
}

run_configuration() {
  set -eEo pipefail
  run $OMARCHY_INSTALL/config/config.sh
  run $OMARCHY_INSTALL/config/theme.sh
  run $OMARCHY_INSTALL/config/branding.sh
  run $OMARCHY_INSTALL/config/git.sh
  run $OMARCHY_INSTALL/config/gpg.sh
  run $OMARCHY_INSTALL/config/timezones.sh
  run $OMARCHY_INSTALL/config/increase-sudo-tries.sh
  run $OMARCHY_INSTALL/config/increase-lockout-limit.sh
  run $OMARCHY_INSTALL/config/ssh-flakiness.sh
  run $OMARCHY_INSTALL/config/detect-keyboard-layout.sh
  run $OMARCHY_INSTALL/config/xcompose.sh
  run $OMARCHY_INSTALL/config/mise-ruby.sh
  run $OMARCHY_INSTALL/config/docker.sh
  run $OMARCHY_INSTALL/config/mimetypes.sh
  run $OMARCHY_INSTALL/config/localdb.sh
  run $OMARCHY_INSTALL/config/sudoless-asdcontrol.sh
  run $OMARCHY_INSTALL/config/hardware/network.sh
  run $OMARCHY_INSTALL/config/hardware/fix-fkeys.sh
  run $OMARCHY_INSTALL/config/hardware/bluetooth.sh
  run $OMARCHY_INSTALL/config/hardware/printer.sh
  run $OMARCHY_INSTALL/config/hardware/usb-autosuspend.sh
  run $OMARCHY_INSTALL/config/hardware/ignore-power-button.sh
  run $OMARCHY_INSTALL/config/hardware/nvidia.sh
  run $OMARCHY_INSTALL/config/hardware/fix-f13-amd-audio-input.sh
}

run_login() {
  set -eEo pipefail
  run $OMARCHY_INSTALL/login/plymouth.sh
  run $OMARCHY_INSTALL/login/limine-snapper.sh
  run $OMARCHY_INSTALL/login/alt-bootloaders.sh
}

run_finishing() {
  set -eEo pipefail
  run $OMARCHY_INSTALL/post-install/pacman.sh
}

# Export all environment variables and functions for gum spin subshells
export OMARCHY_PATH
export OMARCHY_INSTALL
export OMARCHY_CHROOT_INSTALL
export OMARCHY_OFFLINE_INSTALL
export LOG_FILE

# Export all functions
export -f run run_preparation run_packaging run_configuration run_login run_finishing

# Source and export helper functions
source $OMARCHY_INSTALL/preflight/chroot.sh
source $OMARCHY_INSTALL/preflight/start-logs.sh

gum spin --title "Preparing..." -- bash -c 'run_preparation' || exit $?
echo -e "Preparation finished \033[32m[X]\033[0m"

gum spin --title "Installing packages..." -- bash -c 'run_packaging' || exit $?
echo -e "Packages installed \033[32m[X]\033[0m"

gum spin --title "Configuring system..." -- bash -c 'run_configuration' || exit $?
echo -e "System configured \033[32m[X]\033[0m"

gum spin --title "Setting up login..." -- bash -c 'run_login' || exit $?
echo -e "Login setup \033[32m[X]\033[0m"

gum spin --title "Finishing installation..." -- bash -c 'run_finishing' || exit $?

source $OMARCHY_INSTALL/post-install/stop-logs.sh
source $OMARCHY_INSTALL/reboot.sh
