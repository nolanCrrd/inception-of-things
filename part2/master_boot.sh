#!/bin/bash

# Dependencies
sudo apk add ufw

# UFW setup
ufw allow 22/tcp
ufw allow 6443/tcp
ufw allow from 192.168.56.0/24
ufw allow from 10.42.0.0/16
ufw allow from 10.43.0.0/16
ufw --force enable
rc-update add ufw

# K3S
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server \
  --node-ip=$K3S_SERVER_IP \
  --advertise-address=$K3S_SERVER_IP \
  --flannel-iface=eth1 \
  --write-kubeconfig-mode=644 \
  --token=$K3S_TOKEN" sh -
