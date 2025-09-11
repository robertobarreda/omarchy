# Look for BCM4360 802.11ac chipset on Apple
if lspci -nnv | grep -A2 "14e4:43a0" | grep -q "106b:"; then
  pacman -S --noconfirm --needed broadcom-wl dkms linux-headers
fi
