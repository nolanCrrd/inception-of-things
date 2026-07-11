#!/bin/bash

# Dependencies
sudo apk add ufw

# Firewall config
ufw allow 6443/tcp
ufw allow from 10.42.0.0/16 to any
ufw allow from 10.43.0.0/16 to any