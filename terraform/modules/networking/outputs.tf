output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.cicd_vpc.id
}

output "public_subnet_id" {
  description = "ID of the public gitlab subnet"
  value       = aws_subnet.public_gitlab_subnet.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.cicd_vpc.cidr_block
}

output "eks_subnet_ids" {
  description = "IDs of the EKS subnets"
  value       = [aws_subnet.eks_subnet_1.id, aws_subnet.eks_subnet_2.id, aws_subnet.eks_subnet_3.id]
}

output "eks_subnet_azs" {
  description = "Availability zones of the EKS subnets"
  value       = [var.eks_az_1, var.eks_az_2, var.eks_az_3]
}
