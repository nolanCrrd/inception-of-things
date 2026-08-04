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

# Apply app and ingress
echo "waiting server readiness"
until nc -z -w 2 "$K3S_SERVER_IP" 6443 ; do 
    echo "Server isnt set, delaying app launch";
    sleep 5 ;
done

echo "applying app one"
kubectl apply -f /vagrant/app1.yaml
echo "applying app two"
kubectl apply -f /vagrant/app2.yaml
echo "applying app three"
kubectl apply -f /vagrant/app1.yaml
echo "applying ingress"
kubectl apply -f /vagrant/ingress.yaml