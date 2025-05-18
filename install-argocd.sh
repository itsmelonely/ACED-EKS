#!/bin/bash

# Create or update a kubeconfig file for your cluster.
aws eks update-kubeconfig --region ap-southeast-7 --name $EKS_CLUSTER_NAME

# Apply Argo CD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Expose Argo CD server
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Wait for Argo CD server to be ready
echo "Waiting for Argo CD server to be ready..."
sleep 120

# Get initial admin password
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

# Get Argo CD server IP address
ARGOCD_SERVER_IP=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')