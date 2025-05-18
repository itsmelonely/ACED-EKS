#!/bin/bash

# Create a script to check for public IP and update GitLab URL
cat > /usr/local/bin/update-gitlab-url.sh << 'SCRIPT'
#!/bin/bash

# Function to check if GitLab is installed
check_gitlab_installed() {
  if [ -f /etc/gitlab/gitlab.rb ]; then
    return 0
  else
    return 1
  fi
}

# Function to get public IP using IMDSv2
get_public_ip() {
  # Get IMDSv2 token first
  TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" 2>/dev/null)

  if [ ! -z "$TOKEN" ]; then
    # Use token to get public IP
    PUBLIC_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null)
  fi

  # If that fails, try OpenDNS as fallback
  if [ -z "$PUBLIC_IP" ]; then
    PUBLIC_IP=$(dig +short myip.opendns.com @resolver1.opendns.com 2>/dev/null)
  fi

  echo "$PUBLIC_IP"
}

# Function to update GitLab URL
update_gitlab_url() {
  local PUBLIC_IP=$1
  local NEW_URL="http://$PUBLIC_IP"
  local CONFIG_FILE="/etc/gitlab/gitlab.rb"
  local BACKUP_FILE="/etc/gitlab/gitlab.rb.bak"

  echo "$(date): Updating GitLab external URL to $NEW_URL" >> /var/log/gitlab-setup.log

  # Backup config
  cp "$CONFIG_FILE" "$BACKUP_FILE"

  # Update external_url
  sed -i "s|^external_url .*|external_url '$NEW_URL'|" "$CONFIG_FILE"

  # Reconfigure GitLab
  echo "$(date): Running gitlab-ctl reconfigure..." >> /var/log/gitlab-setup.log
  gitlab-ctl reconfigure >> /var/log/gitlab-setup.log 2>&1

  # Restart GitLab
  echo "$(date): Restarting GitLab..." >> /var/log/gitlab-setup.log
  gitlab-ctl restart >> /var/log/gitlab-setup.log 2>&1

  echo "$(date): GitLab external_url has been updated to $NEW_URL" >> /var/log/gitlab-setup.log

  # Create a flag file to indicate successful update
  touch /var/lib/gitlab-url-updated
}

# Main loop
MAX_ATTEMPTS=30
ATTEMPT=0

echo "$(date): Starting GitLab URL update script" >> /var/log/gitlab-setup.log

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
  # Check if GitLab is installed
  if check_gitlab_installed; then
    echo "$(date): GitLab installation detected" >> /var/log/gitlab-setup.log

    # Get public IP
    PUBLIC_IP=$(get_public_ip)

    # If we have a public IP, update GitLab URL
    if [ ! -z "$PUBLIC_IP" ]; then
      echo "$(date): Public IP detected: $PUBLIC_IP" >> /var/log/gitlab-setup.log
      update_gitlab_url "$PUBLIC_IP"
      exit 0
    else
      echo "$(date): No public IP detected yet. Waiting..." >> /var/log/gitlab-setup.log
    fi
  else
    echo "$(date): GitLab not yet installed. Waiting..." >> /var/log/gitlab-setup.log
  fi

  # Increment attempt counter
  ATTEMPT=$((ATTEMPT+1))

  # Wait before next attempt
  sleep 30
done

echo "$(date): Failed to update GitLab URL after $MAX_ATTEMPTS attempts" >> /var/log/gitlab-setup.log
exit 1
SCRIPT

# Make the script executable
chmod +x /usr/local/bin/update-gitlab-url.sh

# Create a systemd service to run the script
cat > /etc/systemd/system/gitlab-url-updater.service << 'SERVICE'
[Unit]
Description=GitLab URL Updater
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/update-gitlab-url.sh
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
SERVICE

# Enable and start the service
systemctl enable gitlab-url-updater.service
systemctl start gitlab-url-updater.service

echo "$(date): GitLab URL updater service has been set up" > /var/log/gitlab-setup.log