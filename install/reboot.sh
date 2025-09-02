#!/bin/bash

clear
tte -i ~/.local/share/omarchy/logo.txt --canvas-width 0 --anchor-text c --frame-rate 920 laseretch
echo
echo "You're done! So we're ready to reboot now..." | tte --canvas-width 0 --anchor-text c --frame-rate 640 wipe

if sudo test -f /etc/sudoers.d/99-omarchy-installer; then
  sudo rm -f /etc/sudoers.d/99-omarchy-installer &>/dev/null
  echo
  echo "Remember to remove USB installer!" | tte --canvas-width 0 --anchor-text c --frame-rate 640 wipe
fi

sleep 5
reboot
