#!/bin/bash

# Use local files for ISO install
if [ -n "${OMARCHY_OFFLINE_INSTALL:-}" ]; then
  ICON_DIR="$HOME/.local/share/applications/icons"

  omarchy-webapp-install "HEY" https://app.hey.com "$ICON_DIR/HEY.png"
  omarchy-webapp-install "Basecamp" https://launchpad.37signals.com "$ICON_DIR/Basecamp.png"
  omarchy-webapp-install "WhatsApp" https://web.whatsapp.com/ "$ICON_DIR/WhatsApp.png"
  omarchy-webapp-install "Google Photos" https://photos.google.com/ "$ICON_DIR/Google Photos.png"
  omarchy-webapp-install "Google Contacts" https://contacts.google.com/ "$ICON_DIR/Google Contacts.png"
  omarchy-webapp-install "Google Messages" https://messages.google.com/web/conversations "$ICON_DIR/Google Messages.png"
  omarchy-webapp-install "ChatGPT" https://chatgpt.com/ "$ICON_DIR/ChatGPT.png"
  omarchy-webapp-install "YouTube" https://youtube.com/ "$ICON_DIR/YouTube.png"
  omarchy-webapp-install "GitHub" https://github.com/ "$ICON_DIR/GitHub.png"
  omarchy-webapp-install "X" https://x.com/ "$ICON_DIR/X.png"
  omarchy-webapp-install "Figma" https://figma.com/ "$ICON_DIR/Figma.png"
  omarchy-webapp-install "Discord" https://discord.com/channels/@me "$ICON_DIR/Discord.png"
  omarchy-webapp-install "Zoom" https://app.zoom.us/wc/home "$ICON_DIR/Zoom.png"
else
  # Online mode - use URLs
  omarchy-webapp-install "HEY" https://app.hey.com https://www.hey.com/assets/images/general/hey.png
  omarchy-webapp-install "Basecamp" https://launchpad.37signals.com https://basecamp.com/assets/images/general/basecamp.png
  omarchy-webapp-install "WhatsApp" https://web.whatsapp.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/whatsapp.png
  omarchy-webapp-install "Google Photos" https://photos.google.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/google-photos.png
  omarchy-webapp-install "Google Contacts" https://contacts.google.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/google-contacts.png
  omarchy-webapp-install "Google Messages" https://messages.google.com/web/conversations https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/google-messages.png
  omarchy-webapp-install "ChatGPT" https://chatgpt.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/chatgpt.png
  omarchy-webapp-install "YouTube" https://youtube.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/youtube.png
  omarchy-webapp-install "GitHub" https://github.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/github-light.png
  omarchy-webapp-install "X" https://x.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/x-light.png
  omarchy-webapp-install "Figma" https://figma.com/ https://www.veryicon.com/download/png/application/app-icon-7/figma-1?s=256
  omarchy-webapp-install "Discord" https://discord.com/channels/@me https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/discord.png
  omarchy-webapp-install "Zoom" https://app.zoom.us/wc/home https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/zoom.png
fi
