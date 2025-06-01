#!/bin/bash

#set variable
EKS_CLUSTER_NAME=$(terraform output -raw eks_cluster_name)
EKS_LBC_ARN=$(terraform output -raw lb_controller_role_arn)

#set kubernetes context
aws eks update-kubeconfig --region ap-southeast-7 --name $EKS_CLUSTER_NAME

#install load balancer controller
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.0.2/cert-manager.yaml
curl -o lbc-install.yaml https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.2.1/docs/install/v2_2_1_full.yaml
sed -i "s/your-cluster-name/$EKS_CLUSTER_NAME/g" lbc-install.yaml
kubectl apply -f lbc-install.yaml
sleep(5)
kubectl annotate serviceaccount -n kube-system aws-load-balancer-controller eks.amazonaws.com/role-arn=$EKS_LBC_ARN

#install argo-cd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml