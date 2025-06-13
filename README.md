# Senior Project - AUTOMATED TOOL FOR DEPLOYING CUSTOM CI/CD PIPELINE USING AMAZON ELASTIC KUBERNETES SERVICES

A comprehensive DevOps platform that provides infrastructure automation, CI/CD pipeline management, and project deployment capabilities using modern cloud-native technologies.

## 🏗️ Architecture Overview

This project consists of three main components:

- **Frontend Application** (`/app`) - Nuxt.js-based web interface
- **Backend API** (`/api`) - Express.js API server with TypeScript
- **Infrastructure as Code** (`/terraform`) - AWS infrastructure automation

## 🚀 Features

- **Infrastructure Automation**: Automated AWS infrastructure provisioning using Terraform
- **CI/CD Pipeline**: GitLab integration with ArgoCD for continuous deployment
- **Kubernetes Management**: EKS cluster setup and management
- **Project Templates**: Pre-configured project templates for quick deployment
- **Web Interface**: Modern, responsive UI built with Nuxt.js and Tailwind CSS

## 📋 Prerequisites

- Ubuntu 22.04+
- Node Package Manager (npm)
- Node Version Manager (nvm)
- Node.js (v20 or higher)
- TypeScript
- PM2
- AWS CLI configured with appropriate credentials
- Terraform (v1.0 or higher)
- Custom GitLab EC2 AMI (explaination in next section)
- an EC2 key pair (for EC2 provisioned by the terraform script)
- kubectl
- NGINX
- Docker (optional, for containerization)

### Setting up Custom GitLab AMI
To create a custom GitLab EC2 AMI, you'll first launch an Ubuntu 22.04 EC2 instance, then manually install and configure GitLab on it, making sure it's set to start automatically on boot. Before creating the AMI, it's a good idea to perform some cleanup, like clearing logs and history. Finally, stop the instance and create an AMI from it. When using this custom AMI with Terraform, you'll leverage user_data to apply instance-specific configurations like the EXTERNAL_URL and initial root password during launch. It's crucial to remember that Linux distributions vary significantly: the package manager (e.g., apt for Ubuntu, yum/dnf for RHEL/CentOS/Amazon Linux), GitLab's installation script and dependencies, and even the default user for SSH access (e.g., ubuntu for Ubuntu, ec2-user for Amazon Linux) will differ, so always consult GitLab's official documentation for your chosen base OS.

## 🛠️ Installation & Setup

### 1. Install Prerequisite
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update
sudo apt-get install -y gnupg software-properties-common
sudo apt-get install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo apt-get install -y terraform
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
nvm install --lts
npm install -g pm2
npm install -g typescript
```

### 2. Clone the Repository
```bash
git clone https://github.com/itsmelonely/ACED-EKS.git
cd ACED-EKS
```

### 3. Frontend Setup

```bash
cd app
npm install
```


### 4. Backend API Setup

```bash
cd api
npm install
tsc
```

### 5. NGINX Reverse Proxy

Install and start NGINX
```bash
sudo apt update
sudo apt install nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

Add this configuration into /etc/nginx/site-available/default
```
server {
	listen 80 default_server;
	listen [::]:80 default_server;


	root /var/www/html;

	# Add index.php to the list if you are using PHP
	index index.html;

	server_name _;

	location / {
		proxy_pass http://localhost:8080;
	}
	
	location /api/ {
		proxy_pass http://localhost:3000/;
	}
		
}
```


## 🏗️ Infrastructure Components

The Terraform configuration provisions:

- **VPC and Networking**: Custom VPC with public/private subnets
- **EKS Cluster**: Managed Kubernetes cluster
- **Security Groups**: Properly configured security rules
- **EC2 Instances**: For GitLab and other services

### Key Infrastructure Scripts

- `install-gitlab.sh` - Automated GitLab CE installation
- `install-argocd.sh` - ArgoCD setup for GitOps
- `initial-kubernetes-setup.sh` - Basic Kubernetes configuration

## 🎯 Usage

### Web Interface

1. Access the web interface at `http://localhost` or `http://host-ip-address`
2. Select a project template
3. Configure your project profile (AWS credentials, region, etc.)
4. Launch your infrastructure and applications

### API Endpoints

The backend API provides endpoints for:
- Project template management
- Infrastructure provisioning
- Configuration management
- Deployment status monitoring

## 📁 Project Structure

```
senior-project/
├── app/                    # Frontend Nuxt.js application
│   ├── components/         # Vue components
│   ├── assets/            # Static assets
│   ├── plugins/           # Nuxt plugins
│   └── server/            # Server-side code
├── api/                   # Backend Express.js API
│   ├── src/               # Source code
│   └── templates/         # Project templates
├── terraform/             # Infrastructure as Code
│   ├── modules/           # Terraform modules
│   ├── main.tf           # Main configuration
│   ├── variables.tf      # Variable definitions
│   └── outputs.tf        # Output definitions
└── scripts/              # Utility scripts
```

## 🚀 Deployment

### Development
```bash
# Start all services
npm run dev  # in /app directory
npm run dev  # in /api directory
```

### Production with PM2

#### Prerequisites
```bash
# Install PM2 globally
npm install -g pm2
```

#### Build and Deploy
```bash
# Build frontend
cd app
npm run generate


# Build API (if using TypeScript)
cd api && tsc

# Start API with PM2
pm2 start api/src/index.js --name "devops-api" --env production

# Start Frontend with PM2
pm2 serve app/dist --name "devops-frontend" --env production

# Setup PM2 to start on system boot
pm2 startup

# Save PM2 configuration
pm2 save
```

#### PM2 Management
```bash
# View running applications
pm2 list

# Monitor applications
pm2 monit

# View logs
pm2 logs

# Restart applications
pm2 restart all

# Stop applications
pm2 stop all
```

#### Infrastructure Deployment
```bash
# Deploy AWS infrastructure
cd terraform && terraform apply
```

## 🔐 Security Considerations

- AWS credentials are managed through IAM roles and policies
- Security groups restrict access to necessary ports only
- GitLab and ArgoCD are configured with secure defaults
- All sensitive data should be stored in environment variables

## 📝 License

This project is part of a senior project and is for educational purposes.

## 🆘 Troubleshooting

### Common Issues

1. **Terraform Apply Fails**
   - Ensure AWS credentials are properly configured
   - Check if the specified region supports all required services

2. **EKS Cluster Access Issues**
   - Run `aws eks update-kubeconfig --region <region> --name <cluster-name>`
   - Verify IAM permissions for EKS access

3. **GitLab Installation Issues**
   - Check if the EC2 instance has sufficient resources
   - Verify security group allows HTTP/HTTPS traffic
---

**Note**: This is a senior project developed for educational purposes. Please ensure you understand the AWS costs associated with running this infrastructure before deployment.
