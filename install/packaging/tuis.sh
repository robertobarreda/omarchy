#!/bin/bash

# Use local files for offline install
if [ "${OMARCHY_INSTALL_MODE:-offline}" = "offline" ]; then
  ICON_DIR="$HOME/.local/share/applications/icons"

  omarchy-tui-install "Disk Usage" "bash -c 'dust -r; read -n 1 -s'" float "$ICON_DIR/Disk Usage.png"
  omarchy-tui-install "Docker" "lazydocker" tile "$ICON_DIR/Docker.png"
else
  # Online mode - use URLs
  omarchy-tui-install "Disk Usage" "bash -c 'dust -r; read -n 1 -s'" float https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/qdirstat.png
  omarchy-tui-install "Docker" "lazydocker" tile https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/docker.png
fi
