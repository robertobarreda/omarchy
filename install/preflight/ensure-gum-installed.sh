# Ensure gum is installed before we use it
if ! command -v gum &>/dev/null; then
  echo "Installing gum for installer UI..."
  sudo pacman -S --needed --noconfirm gum
fi
