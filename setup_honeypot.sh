#!/bin/bash

echo "=== Updating system ==="
sudo apt update -y

echo "=== Installing dependencies ==="
sudo apt install -y python3 python3-pip python3-virtualenv \
    libssl-dev libffi-dev build-essential libpython3-dev \
    git iptables-persistent

echo "=== Installing Python packages ==="
pip3 install pandas scikit-learn joblib netmiko --break-system-packages

echo "=== Cloning Cowrie ==="
cd ~
rm -rf cowrie
git clone https://github.com/cowrie/cowrie
cd cowrie

echo "=== Setting up Cowrie virtualenv ==="
python3 -m virtualenv cowrie-env
source cowrie-env/bin/activate
pip install -e .
pip install -r requirements.txt

echo "=== Configuring Cowrie ==="
cp etc/cowrie.cfg.dist etc/cowrie.cfg
sed -i 's/^#\?hostname\s*=.*/hostname = webserver01/' etc/cowrie.cfg
sed -i 's|tcp:6415:interface=127.0.0.1|tcp:2222:interface=0.0.0.0|' etc/cowrie.cfg

echo "=== Setting up iptables ==="
sudo iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 2222
sudo netfilter-persistent save

echo "=== Starting Cowrie ==="
cowrie start
cowrie status

echo "=== Done! ==="
echo "Cowrie is running on port 2222"
echo "Logs at ~/cowrie/var/log/cowrie/"
