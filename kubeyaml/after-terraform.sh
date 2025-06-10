#!/bin/bash

#set variable
EKS_CLUSTER_NAME=$(terraform output -raw eks_cluster_name)
EKS_LBC_ARN=$(terraform output -raw lb_controller_role_arn)

#install kubectl
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.3/2025-04-17/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
rm ./kubectl


#set kubernetes context
aws eks update-kubeconfig --region ap-southeast-7 --name $EKS_CLUSTER_NAME

#to install load balancer controller please follow this guide https://docs.aws.amazon.com/eks/latest/userguide/lbc-manifest.html
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.13.5/cert-manager.yaml
curl -Lo v2_11_0_full.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.11.0/v2_11_0_full.yaml
sed -i.bak -e '690,698d' ./v2_11_0_full.yaml
sed -i.bak -e "s|your-cluster-name|$EKS_CLUSTER_NAME|" ./v2_11_0_full.yaml
#add ingressclass, vpc, region-code manually before apply, the instuction is in the guide
kubectl apply -f v2_11_0_full.yaml
curl -Lo v2_11_0_ingclass.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.11.0/v2_11_0_ingclass.yaml
kubectl apply -f v2_11_0_ingclass.yaml
# sleep(5)
# kubectl annotate serviceaccount -n kube-system aws-load-balancer-controller eks.amazonaws.com/role-arn=$EKS_LBC_ARN

#install argo-cd https://argo-cd.readthedocs.io/en/latest/operator-manual/ingress/
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d