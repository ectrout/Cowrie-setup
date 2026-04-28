#!/bin/bash
# Run this every time Kali reboots

sudo ip link set eth0 up
sudo ip addr add 192.168.40.10/24 dev eth0
sudo ip route add default via 192.168.40.1
echo "Network configured, ready to attack"
