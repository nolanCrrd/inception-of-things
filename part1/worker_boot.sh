#!/bin/bash

# K3S
curl -sfL https://get.k3s.io | K3S_URL=https://$K3S_SERVER_IP:6443 K3S_TOKEN=$K3S_TOKEN sh -s -
sudo cp /etc/rancher/k3s/k3s-agent.env /etc/conf.d/k3s-agent
