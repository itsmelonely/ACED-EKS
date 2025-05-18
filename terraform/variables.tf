variable "vpc_cidr" {
  description = "CIDR for VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "public_gitlabcidr" {
  description = "CIDR for public gitlab subnet, if empty will be derived from VPC CIDR"
  type = string
  default = ""
}

variable "gitlab_instance_type" {
  description = "instance type for gitlab ec2"
  type = string
  default = "t3.medium"
}

variable "nodegroup_instance_type" {
  description = "instance type for eks node"
  type = string
  default = "t3.small"
}

variable "key_name" {
  type        = string
  description = "ec2 key pair, it will search the given key before create ec2"
  default     = "project_cicd_test"
}

variable "root_volume_size" {
  type        = number
  description = "root volume size in GiB"
  default     = 25
}

variable "region" {
  type        = string
  description = "region where we run terraform"
  default     = "ap-southeast-7"
}

variable "ecr_name" {
  type        = string
  description = "Name of the ECR repository"
  default     = "senior-project"
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "senior-project-eks"
}

variable "eks_subnet_cidr_1" {
  description = "CIDR for first EKS public subnet, if empty will be derived from VPC CIDR"
  type        = string
  default     = ""
}

variable "eks_subnet_cidr_2" {
  description = "CIDR for second EKS public subnet, if empty will be derived from VPC CIDR"
  type        = string
  default     = ""
}

variable "eks_subnet_cidr_3" {
  description = "CIDR for third EKS public subnet, if empty will be derived from VPC CIDR"
  type        = string
  default     = ""
}
