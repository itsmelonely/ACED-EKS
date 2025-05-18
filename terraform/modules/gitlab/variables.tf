variable "ami_id" {
  description = "AMI ID for the GitLab instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for GitLab EC2"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where to launch the instance"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID to attach to the instance"
  type        = string
}

variable "root_volume_size" {
  description = "Root volume size in GiB"
  type        = number
  default     = 10
}

variable "random_suffix" {
  description = "Random suffix to add to resource names"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile name to attach to the instance"
  type        = string
}
