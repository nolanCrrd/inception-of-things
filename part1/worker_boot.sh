#!/bin/bash

# K3S
echo "agent waiting master to be set"
until nc -z -w 2 "$K3S_SERVER_IP" 6443 ; do 
    echo "master k3s isn't fully set, delaying agent k3s launch";
    sleep 5 ;
done
echo "launching k3s in agent";
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent \
  --server=https://$K3S_SERVER_IP:6443 \
  --node-ip=$K3S_AGENT_IP \
  --flannel-iface=eth1 \
  --token=$K3S_TOKEN" sh -
  
#sh -sudo cp /etc/rancher/k3s/k3s-agent.env /etc/conf.d/k3s-agent
