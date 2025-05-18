#!/bin/bash

# Exit on any failure
set -e

# Variables
EXTERNAL_URL="http://$(dig +short myip.opendns.com @resolver1.opendns.com)"
GITLAB_PACKAGE_URL="https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh"
GITLAB_ROOT_PASSWORD="passwordheheboi123"

# Update system
sudo apt-get update -y
sudo apt-get upgrade -y

# Install dependencies
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl

# Add GitLab package repository
curl -sS "$GITLAB_PACKAGE_URL" | sudo bash

# Install GitLab CE
sudo EXTERNAL_URL="$EXTERNAL_URL" GITLAB_ROOT_PASSWORD="$GITLAB_ROOT_PASSWORD" apt-get install -y gitlab-ce

# Reconfigure GitLab
sudo gitlab-ctl reconfigure

# Output external URL
echo "GitLab installed at: $EXTERNAL_URL"