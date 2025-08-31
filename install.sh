#!/bin/bash

# Set up logging if we're in a chroot install environment
if [ -n "$OMARCHY_CHROOT_INSTALL" ]; then
  exec > >(tee -a /var/log/omarchy-install.log)
  exec 2>&1
  echo "=== Omarchy Installation Started: $(date) ==="
fi

# Exit immediately if a command exits with a non-zero status
set -eE

OMARCHY_PATH="$HOME/.local/share/omarchy"
OMARCHY_INSTALL="$OMARCHY_PATH/install"
export PATH="$OMARCHY_PATH/bin:$PATH"

run() {
  echo "Executing $(basename "$1")..."
  source "$1"
  echo "Finished executing $(basename "$1")"
}

# Preparation
run $OMARCHY_INSTALL/preflight/show-env.sh
run $OMARCHY_INSTALL/preflight/trap-errors.sh
run $OMARCHY_INSTALL/preflight/guard.sh
run $OMARCHY_INSTALL/preflight/chroot.sh
run $OMARCHY_INSTALL/preflight/pacman.sh
run $OMARCHY_INSTALL/preflight/migrations.sh
run $OMARCHY_INSTALL/preflight/first-run-mode.sh

# Packaging
run $OMARCHY_INSTALL/packages.sh
run $OMARCHY_INSTALL/packaging/fonts.sh
run $OMARCHY_INSTALL/packaging/lazyvim.sh
run $OMARCHY_INSTALL/packaging/webapps.sh
run $OMARCHY_INSTALL/packaging/tuis.sh

# Configuration
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

# Login
run $OMARCHY_INSTALL/login/plymouth.sh
run $OMARCHY_INSTALL/login/limine-snapper.sh
run $OMARCHY_INSTALL/login/alt-bootloaders.sh

# Finishing
run $OMARCHY_INSTALL/post-install.sh
run $OMARCHY_INSTALL/reboot.sh
