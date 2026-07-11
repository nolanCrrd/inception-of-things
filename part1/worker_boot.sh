#!/bin/bash

# K3S
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent \
  --server=https://$K3S_SERVER_IP:6443 \
  --node-ip=$K3S_AGENT_IP \
  --flannel-iface=eth1 \
  --token=$K3S_TOKEN"
  
#sh -sudo cp /etc/rancher/k3s/k3s-agent.env /etc/conf.d/k3s-agent
