#!/bin/bash

# Exit on any failure
set -e

# Download the latest version of kubectl
curl -O https://s3.ap-southeast-7.amazonaws.com/amazon-eks/1.33.0/2025-05-01/bin/linux/amd64/kubectl

# Apply execute permissions to the binary.
chmod +x ./kubectl

# Copy the binary to a folder in PATH.
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH

# dd the $HOME/bin path to your shell initialization file so that it is configured when you open a shell.
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bash_profile

# Set environtment variables
export LBC_ARN=$(terraform output -raw lb_controller_role_arn)
export CLUSTER_NAME=$(terraform output -raw cluster_name)
export AWS_REGION=$(terraform output -raw aws_region)

# Get kubernetes cluster's context from AWS
aws eks --region $AWS_REGION update-kubeconfig --name $CLUSTER_NAME