#!/bin/bash

clear
tte -i ~/.local/share/omarchy/logo.txt --canvas-width 0 --anchor-text c --frame-rate 920 laseretch
echo
echo
echo "You're done!" | tte --canvas-width 0 --anchor-text c --frame-rate 640 wipe

# Display installation stats if available
if [ -f "$LOG_FILE" ] && grep -q "Installation Time Summary" "$LOG_FILE" 2>/dev/null; then
  echo
  echo
  # Build the complete stats block and pass to tte all at once
  STATS=$(tail -n 20 "$LOG_FILE" | sed -n '/=== Installation Time Summary ===/,/^===/p' | grep -E "^(Archinstall|Omarchy|Total):")
  {
    echo "Installation Time Summary"
    echo
    echo "$STATS"
  } | tte --canvas-width 0 --anchor-text c --frame-rate 200 waves
fi

if sudo test -f /etc/sudoers.d/99-omarchy-installer; then
  sudo rm -f /etc/sudoers.d/99-omarchy-installer &>/dev/null
  echo
  echo "Remember to remove USB installer!" | tte --canvas-width 0 --anchor-text c --frame-rate 640 wipe
fi

echo
gum confirm --default --affirmative "Reboot Now" --negative "" "" && sudo reboot
