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

- Node.js (v18 or higher)
- AWS CLI configured with appropriate credentials
- Terraform (v1.0 or higher)
- kubectl
- Docker (optional, for containerization)

## 🛠️ Installation & Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd senior-project
```

### 2. Frontend Setup

```bash
cd app
npm install
npm run dev
```

The frontend will be available at `http://localhost:3000`

### 3. Backend API Setup

```bash
cd api
npm install
npm run dev
```

### 4. NGINX Reverse Proxy

Add this configuration into nginx file
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

1. Access the web interface at `http://localhost:3000`
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

## 🔧 Configuration

### Environment Variables

Create appropriate environment files for each component:

**Frontend (.env)**
```
API_BASE_URL=http://localhost:3001
```

**Backend (.env)**
```
PORT=3001
DATABASE_URL=your_database_url
AWS_REGION=ap-southeast-7
```

**Terraform (var.tfvars)**
```
region = "ap-southeast-7"
vpc_cidr = "10.0.0.0/16"
eks_cluster_name = "your-cluster-name"
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
cd app && npm run build

# Build API (if using TypeScript)
cd api && npm run build

# Start API with PM2
pm2 start api/src/index.js --name "devops-api" --env production

# Start Frontend with PM2
pm2 start app/.output/server/index.mjs --name "devops-frontend" --env production

# Save PM2 configuration
pm2 save

# Setup PM2 to start on system boot
pm2 startup
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
