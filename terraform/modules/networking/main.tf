locals {
  # Extract the first two octets from the VPC CIDR
  vpc_prefix = regex("^(\\d+\\.\\d+)\\..*", var.vpc_cidr)[0]
  
  # Define subnet CIDRs based on VPC CIDR prefix
  public_gitlab_cidr = var.public_subnetcidr != "" ? var.public_subnetcidr : "${local.vpc_prefix}.0.0/24"
  eks_subnet_cidr_1 = var.eks_subnet_cidr_1 != "" ? var.eks_subnet_cidr_1 : "${local.vpc_prefix}.10.0/24"
  eks_subnet_cidr_2 = var.eks_subnet_cidr_2 != "" ? var.eks_subnet_cidr_2 : "${local.vpc_prefix}.20.0/24"
  eks_subnet_cidr_3 = var.eks_subnet_cidr_3 != "" ? var.eks_subnet_cidr_3 : "${local.vpc_prefix}.30.0/24"
}

resource "aws_vpc" "cicd_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "cicd-vpc-${var.random_suffix}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cicd_vpc.id

  tags = {
    Name = "cicd-igw-${var.random_suffix}"
  }
}

resource "aws_subnet" "public_gitlab_subnet" {
  vpc_id                  = aws_vpc.cicd_vpc.id
  cidr_block              = local.public_gitlab_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone

  tags = {
    Name = "cicd-public-gitlab-subnet-${var.random_suffix}"
  }
}

# EKS Public Subnets
resource "aws_subnet" "eks_subnet_1" {
  vpc_id                  = aws_vpc.cicd_vpc.id
  cidr_block              = local.eks_subnet_cidr_1
  map_public_ip_on_launch = true
  availability_zone       = var.eks_az_1

  tags = {
    Name = "eks-subnet-1-${var.random_suffix}"
    "kubernetes.io/cluster/${var.eks_cluster_name}-${var.random_suffix}" = "shared"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "eks_subnet_2" {
  vpc_id                  = aws_vpc.cicd_vpc.id
  cidr_block              = local.eks_subnet_cidr_2
  map_public_ip_on_launch = true
  availability_zone       = var.eks_az_2

  tags = {
    Name = "eks-subnet-2-${var.random_suffix}"
    "kubernetes.io/cluster/${var.eks_cluster_name}-${var.random_suffix}" = "shared"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "eks_subnet_3" {
  vpc_id                  = aws_vpc.cicd_vpc.id
  cidr_block              = local.eks_subnet_cidr_3
  map_public_ip_on_launch = true
  availability_zone       = var.eks_az_3

  tags = {
    Name = "eks-subnet-3-${var.random_suffix}"
    "kubernetes.io/cluster/${var.eks_cluster_name}-${var.random_suffix}" = "shared"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.cicd_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "cicd-public-rt-${var.random_suffix}"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_gitlab_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Associate EKS subnets with the public route table
resource "aws_route_table_association" "eks_rt_assoc_1" {
  subnet_id      = aws_subnet.eks_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "eks_rt_assoc_2" {
  subnet_id      = aws_subnet.eks_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "eks_rt_assoc_3" {
  subnet_id      = aws_subnet.eks_subnet_3.id
  route_table_id = aws_route_table.public_rt.id
}
