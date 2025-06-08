# Terraform Infrastructure - DevOps Platform

This terraform configuration is for the **basic_pipeline.zip** template and provisions a complete DevOps infrastructure on AWS.

## 🏗️ Infrastructure Overview

This Terraform configuration creates a comprehensive DevOps platform with the following components:

- **VPC & Networking**: Custom VPC with public/private subnets
- **EKS Cluster**: Managed Kubernetes cluster for container orchestration
- **GitLab Instance**: Self-hosted GitLab CE for source code management and CI/CD
- **ECR Repository**: Container registry for Docker images
- **IAM Roles**: Proper permissions for all services
- **Security Groups**: Network security configurations

## 📋 Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform (v1.0 or higher)
- An existing EC2 Key Pair named `project_cicd_test` (or update the variable)

## 🚀 Quick Start

### 1. Initialize Terraform
```bash
terraform init
```

### 2. Review Configuration
```bash
terraform plan -var-file="var.tfvars"
```

### 3. Deploy Infrastructure
```bash
# Using the provided script
./apply-terraform.sh

# Or manually
terraform apply -var-file="var.tfvars"
```

### 4. Destroy Infrastructure
```bash
# Using the provided script
./destroy-terraform.sh

# Or manually
terraform destroy -var-file="var.tfvars"
```

## 📁 File Structure

```
terraform/
├── main.tf                 # Main configuration with module calls
├── variables.tf            # Variable definitions
├── outputs.tf             # Output definitions
├── var.tfvars             # Variable values
├── data.tf                # Data sources
├── random.tf              # Random resource generation
├── requirement.tf         # Provider requirements
├── apply-terraform.sh     # Deployment script
├── destroy-terraform.sh   # Destruction script
├── pre-install.sh         # Pre-installation setup
├── after-terraform.sh     # Post-deployment setup
└── modules/               # Terraform modules
    ├── networking/        # VPC, subnets, routing
    ├── security/          # Security groups
    ├── iam/              # IAM roles and policies
    ├── gitlab/           # GitLab EC2 instance
    ├── ecr/              # Container registry
    └── eks/              # EKS cluster and node groups
```

## 🔧 Configuration Variables

### Core Variables
| Variable | Description | Default | Type |
|----------|-------------|---------|------|
| `region` | AWS region | `ap-southeast-7` | string |
| `vpc_cidr` | VPC CIDR block | `10.0.0.0/16` | string |
| `eks_cluster_name` | EKS cluster name | `senior-project-eks` | string |
| `key_name` | EC2 key pair name | `project_cicd_test` | string |

### Instance Configuration
| Variable | Description | Default | Type |
|----------|-------------|---------|------|
| `gitlab_instance_type` | GitLab EC2 instance type | `t3.medium` | string |
| `nodegroup_instance_type` | EKS node instance type | `t3.small` | string |
| `root_volume_size` | Root volume size (GiB) | `25` | number |

### Networking
| Variable | Description | Default | Type |
|----------|-------------|---------|------|
| `public_gitlabcidr` | GitLab subnet CIDR | Auto-derived | string |
| `eks_subnet_cidr_1` | First EKS subnet CIDR | Auto-derived | string |
| `eks_subnet_cidr_2` | Second EKS subnet CIDR | Auto-derived | string |
| `eks_subnet_cidr_3` | Third EKS subnet CIDR | Auto-derived | string |

## 📤 Outputs

After deployment, Terraform provides the following outputs:

### Infrastructure
- `vpc_id` - VPC identifier
- `vpc_cidr` - VPC CIDR block
- `public_subnet_id` - Public subnet identifier
- `random_id` - Random suffix for resource naming

### GitLab
- `gitlab_public_ip` - GitLab instance public IP
- `gitlab_role_arn` - GitLab IAM role ARN
- `gitlab_instance_profile_name` - Instance profile name

### EKS
- `eks_cluster_name` - EKS cluster name
- `eks_cluster_endpoint` - EKS API endpoint
- `eks_cluster_role_arn` - EKS cluster IAM role ARN
- `eks_node_role_arn` - EKS node group IAM role ARN
- `oidc_provider_arn` - OIDC provider ARN
- `lb_controller_role_arn` - Load balancer controller role ARN

### ECR
- `ecr_repository_url` - Container registry URL

## 🔐 Security Features

- **IAM Roles**: Least privilege access for all services
- **Security Groups**: Restricted network access
- **VPC**: Isolated network environment
- **Private Subnets**: EKS nodes in private subnets
- **Public Subnet**: GitLab in public subnet with controlled access

## 🛠️ Post-Deployment Setup

After Terraform completes, run the post-deployment scripts:

```bash
# Pre-installation setup
./pre-install.sh

# Post-deployment configuration
./after-terraform.sh
```

These scripts will:
- Configure kubectl for EKS access
- Install ArgoCD
- Set up GitLab integration
- Configure necessary Kubernetes resources

## 📝 Template Management

**Important**: This terraform configuration is for the **basic_pipeline.zip** template.

### Making Changes
If you make any changes in this directory:
1. Test your changes thoroughly
2. Zip the entire terraform directory as `basic_pipeline.zip`
3. Place the zip file in `api/templates/`

### Adding New Templates
If you have any other template:
1. Create a new terraform configuration
2. Zip it with an appropriate name
3. Put it in `api/templates/`
4. Update the API to recognize the new template

## 🔍 Troubleshooting

### Common Issues

1. **Key Pair Not Found**
   - Ensure the EC2 key pair exists in your AWS account
   - Update the `key_name` variable if using a different key

2. **Region Not Supported**
   - Verify that `ap-southeast-7` supports all required services
   - Update AMI IDs if changing regions

3. **Insufficient Permissions**
   - Ensure your AWS credentials have necessary permissions
   - Check IAM policies for EKS, EC2, VPC, and ECR access

4. **Resource Limits**
   - Check AWS service quotas
   - Verify instance types are available in your region

### Useful Commands

```bash
# Check Terraform state
terraform state list

# Show specific resource
terraform state show <resource_name>

# Import existing resources
terraform import <resource_type>.<name> <resource_id>

# Refresh state
terraform refresh -var-file="var.tfvars"
```

## 💰 Cost Considerations

This infrastructure will incur AWS costs for:
- EC2 instances (GitLab + EKS nodes)
- EKS cluster management
- NAT Gateway (if using private subnets)
- Data transfer
- ECR storage

Estimated monthly cost: $50-150 depending on usage and instance types.

## 🤝 Contributing

When modifying this infrastructure:
1. Test changes in a separate environment first
2. Update documentation for any new variables or outputs
3. Ensure backward compatibility
4. Update the template zip file in the API

---

**Note**: This infrastructure is designed for development and testing purposes. For production use, consider additional security hardening, monitoring, and backup strategies.