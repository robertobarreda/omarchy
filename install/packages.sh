#!/bin/bash

# Read packages from the unified package list file
PACKAGE_LIST="$OMARCHY_INSTALL/omarchy-base.packages"

# Check if package list exists
if [ ! -f "$PACKAGE_LIST" ]; then
  echo "Error: Package list not found at $PACKAGE_LIST"
  exit 1
fi

# Read packages from file (skip comments and empty lines)
mapfile -t packages < <(grep -v '^#' "$PACKAGE_LIST" | grep -v '^$')

# Install all packages
sudo pacman -S --noconfirm --needed "${packages[@]}"

