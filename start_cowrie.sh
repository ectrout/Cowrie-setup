#!/bin/bash
# Run this every time Ubuntu reboots

# Set network interface up
sudo ip link set enp0s9 up
sudo ip addr add 192.168.30.10/24 dev enp0s9
sudo ip route add default via 192.168.30.1

# Restore iptables rules
sudo netfilter-persistent reload

# Start Cowrie
cd ~/cowrie
source cowrie-env/bin/activate
cowrie start
echo "Cowrie started, listening on port 2222"
