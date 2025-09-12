#!/bin/bash

# Look for BCM4360 802.11ac chipset on Apple
echo "Checking for Apple BCM4360 wireless chipset..."
if lspci -nnv | grep -A2 "14e4:43a0" | grep -q "106b:"; then
  echo "Apple BCM4360 detected, installing broadcom-wl driver..."
  sudo pacman -S --noconfirm --needed broadcom-wl dkms linux-headers
else
  echo "Apple BCM4360 not detected, skipping driver installation"
fi
