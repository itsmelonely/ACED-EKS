variable "vpc_cidr" {
  description = "CIDR for VPC"
  type        = string
}

variable "public_subnetcidr" {
  description = "CIDR for public gitlab subnet, if empty will be derived from VPC CIDR"
  type        = string
  default     = ""
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
  default     = "ap-southeast-7a"
}

variable "random_suffix" {
  description = "Random suffix to add to resource names"
  type        = string
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

variable "eks_az_1" {
  description = "Availability zone for first EKS subnet"
  type        = string
  default     = "ap-southeast-7a"
}

variable "eks_az_2" {
  description = "Availability zone for second EKS subnet"
  type        = string
  default     = "ap-southeast-7b"
}

variable "eks_az_3" {
  description = "Availability zone for third EKS subnet"
  type        = string
  default     = "ap-southeast-7c"
}
