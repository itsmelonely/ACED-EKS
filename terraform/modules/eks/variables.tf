variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "random_suffix" {
  description = "Random suffix to add to resource names"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "IDs of the subnets for EKS cluster"
  type        = list(string)
}

variable "eks_cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role"
  type        = string
}

variable "eks_node_role_arn" {
  description = "ARN of the EKS node IAM role"
  type        = string
}

variable "nodegroup_instance_type" {
  description = "Instance type for the EKS node group"
  type        = string
  default     = "t3.small"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.32"
}

variable "key_name" {
  description = "EC2 key pair name for SSH access to the nodes"
  type        = string
  default     = "project_cicd_test"
}
