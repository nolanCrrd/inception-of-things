#!/bin/bash

# K3S
curl -sfL https://get.k3s.io | K3S_URL=$K3S_SERVER_IP K3S_TOKEN=$K3S_TOKEN sh -s -