# Configure pacman
sudo cp -f ~/.local/share/omarchy/default/pacman/pacman.conf /etc/pacman.conf
sudo cp -f ~/.local/share/omarchy/default/pacman/mirrorlist /etc/pacman.d/mirrorlist

# Enable multilib repository for nvidia users
if lspci | grep -qi 'nvidia' && ! grep -q '^\[multilib\]' /etc/pacman.conf; then
  sudo sed -i '/^#\s*\[multilib\]/,/^#\s*Include/ s/^#\s*//' /etc/pacman.conf
fi
