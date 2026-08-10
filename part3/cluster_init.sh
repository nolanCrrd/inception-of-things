#!/bin/bash

#create cluster
k3d cluster create --config k3d-config.yaml
#create name space
kubectl create namespace argocd
kubectl create namespace dev
#deploy argocd (server side is needed to avoid error because argo cd config is too heavy to be computed localy)
kubectl apply --server-side -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f argocd-nodeport.yaml
kubectl apply -f application.yaml
