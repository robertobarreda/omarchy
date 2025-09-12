#!/bin/bash

if lspci -nnv | grep -A2 "14e4:43a0" | grep -q "106b:"; then
  echo "Apple BCM4360 detected"
  sudo pacman -S --noconfirm --needed broadcom-wl dkms linux-headers
fi
