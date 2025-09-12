#!/bin/bash

mapfile -t packages < <(grep -v '^#' "$OMARCHY_INSTALL/omarchy-base.packages" | grep -v '^$')

sudo pacman -S --noconfirm --needed "${packages[@]}"
