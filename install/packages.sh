#!/bin/bash

PACKAGE_LIST="$OMARCHY_INSTALL/omarchy-base.packages"

mapfile -t packages < <(grep -v '^#' "$PACKAGE_LIST" | grep -v '^$')

sudo pacman -S --noconfirm --needed "${packages[@]}"
