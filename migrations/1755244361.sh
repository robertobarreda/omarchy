echo "Tuning MTU probing for more reliable SSH and Tailscale performance"

sudo sed -i 's/^net.ipv4.tcp_mtu_probing=1/net.ipv4.tcp_mtu_probing=2/' /etc/sysctl.d/99-sysctl.conf
