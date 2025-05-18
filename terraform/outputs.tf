output "random_id" {
  description = "Random ID used as suffix for resources"
  value       = random_id.id.hex
}

output "gitlab_public_ip" {
  description = "Public IP address of the GitLab instance"
  value       = module.gitlab.public_ip
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = module.networking.vpc_cidr
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.networking.public_subnet_id
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}

# IAM Role outputs
output "eks_cluster_role_arn" {
  description = "ARN of the EKS Cluster IAM Role"
  value       = module.iam.eks_cluster_role_arn
}

output "eks_node_role_arn" {
  description = "ARN of the EKS Node IAM Role"
  value       = module.iam.eks_node_role_arn
}

output "gitlab_role_arn" {
  description = "ARN of the GitLab IAM Role"
  value       = module.iam.gitlab_role_arn
}

output "gitlab_instance_profile_name" {
  description = "Name of the GitLab Instance Profile"
  value       = module.iam.gitlab_instance_profile_name
}

# EKS outputs
output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.eks_cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint for the EKS cluster"
  value       = module.eks.eks_cluster_endpoint
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC provider for the EKS cluster"
  value       = module.eks.oidc_provider_arn
}

output "lb_controller_role_arn" {
  description = "ARN of the Load Balancer Controller IAM role"
  value       = module.eks.lb_controller_role_arn
}
