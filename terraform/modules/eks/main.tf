resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.eks_cluster_name}-${var.random_suffix}"
  role_arn = var.eks_cluster_role_arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_public_access  = true
    endpoint_private_access = false
    security_group_ids      = [aws_security_group.eks_cluster_sg.id]
  }

  # Set authentication mode to API only
  kubernetes_network_config {
    ip_family = "ipv4"
  }

  # Configure access to use EKS API only
  access_config {
    authentication_mode = "API"
  }

  depends_on = [
    aws_security_group.eks_cluster_sg
  ]

  tags = {
    Name = "${var.eks_cluster_name}-${var.random_suffix}"
  }
}

resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-cluster-sg-${var.random_suffix}"
  description = "Security group for EKS cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all incoming traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outgoing traffic"
  }

  tags = {
    Name = "eks-cluster-sg-${var.random_suffix}"
  }
}

resource "aws_security_group" "eks_node_sg" {
  name        = "eks-node-sg-${var.random_suffix}"
  description = "Security group for EKS node group"
  vpc_id      = var.vpc_id

  # SSH access for remote connection
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access from anywhere"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all incoming traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outgoing traffic"
  }

  tags = {
    Name = "eks-node-sg-${var.random_suffix}"
  }
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-nodegroup-${var.random_suffix}"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.subnet_ids
  instance_types  = [var.nodegroup_instance_type]
  ami_type        = "AL2023_x86_64_STANDARD" # Amazon Linux 2023
  
  # Enable remote access to nodes
  remote_access {
    ec2_ssh_key               = var.key_name
    source_security_group_ids = [aws_security_group.eks_node_sg.id]
  }

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_eks_cluster.eks_cluster
  ]

  tags = {
    Name = "eks-nodegroup-${var.random_suffix}"
  }
}

# Create IAM access for the specified user with ClusterAdmin policy
resource "aws_eks_access_entry" "tf_test_user" {
  cluster_name      = aws_eks_cluster.eks_cluster.name
  principal_arn     = "arn:aws:iam::204487319517:user/tf-test"
  type              = "STANDARD"
  
  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}

resource "aws_eks_access_policy_association" "tf_test_user_admin" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = "arn:aws:iam::204487319517:user/tf-test"
  access_scope {
    type = "cluster"
  }
  
  depends_on = [
    aws_eks_access_entry.tf_test_user
  ]
}

# Get caller identity for account ID
data "aws_caller_identity" "current" {}

# Extract OIDC provider URL from the EKS cluster
locals {
  oidc_provider = replace(aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")
}

# Create OIDC provider for the EKS cluster
resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
  
  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}

# Get the TLS certificate for the OIDC provider
data "tls_certificate" "eks_oidc" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
  
  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}

#######################
# EKS Add-ons
#######################

# CoreDNS Add-on
resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = "coredns"
  addon_version               = "v1.11.4-eksbuild.2" # Specified version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  
  depends_on = [
    aws_eks_cluster.eks_cluster,
    aws_eks_node_group.eks_node_group
  ]
}

# Create IAM policy for VPC CNI
resource "aws_iam_policy" "vpc_cni_policy" {
  name        = "AmazonEKS_CNI_Policy-${var.random_suffix}"
  description = "IAM policy for Amazon VPC CNI"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:AssignPrivateIpAddresses",
          "ec2:AttachNetworkInterface",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeInstances",
          "ec2:DescribeTags",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeInstanceTypes",
          "ec2:DetachNetworkInterface",
          "ec2:ModifyNetworkInterfaceAttribute",
          "ec2:UnassignPrivateIpAddresses"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateTags"
        ]
        Resource = [
          "arn:aws:ec2:*:*:network-interface/*"
        ]
      }
    ]
  })
}

# Create IAM role for VPC CNI
resource "aws_iam_role" "vpc_cni_role" {
  name = "AmazonEKS_CNI_Role-${var.random_suffix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${local.oidc_provider}:sub" = "system:serviceaccount:kube-system:aws-node"
          }
        }
      }
    ]
  })
}

# Attach policy to VPC CNI role
resource "aws_iam_role_policy_attachment" "vpc_cni_attachment" {
  role       = aws_iam_role.vpc_cni_role.name
  policy_arn = aws_iam_policy.vpc_cni_policy.arn
}

# VPC CNI Add-on
resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = "vpc-cni"
  addon_version               = "v1.19.2-eksbuild.1" # Specified version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  service_account_role_arn    = aws_iam_role.vpc_cni_role.arn
  
  depends_on = [
    aws_eks_cluster.eks_cluster,
    aws_eks_node_group.eks_node_group,
    aws_iam_role_policy_attachment.vpc_cni_attachment
  ]
}

# kube-proxy Add-on
resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = "kube-proxy"
  addon_version               = "v1.32.0-eksbuild.2" # Specified version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  
  depends_on = [
    aws_eks_cluster.eks_cluster,
    aws_eks_node_group.eks_node_group
  ]
}

# Create IAM policy for AWS Load Balancer Controller from the JSON file
resource "aws_iam_policy" "lb_controller_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy-${var.random_suffix}"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = file("${path.module}/lbc_policy.json")
}

# Create IAM role for AWS Load Balancer Controller
resource "aws_iam_role" "lb_controller_role" {
  name = "AmazonEKS_LBC_Role-${var.random_suffix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${local.oidc_provider}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      }
    ]
  })
}

# Attach policy to AWS Load Balancer Controller role
resource "aws_iam_role_policy_attachment" "lb_controller_attachment" {
  role       = aws_iam_role.lb_controller_role.name
  policy_arn = aws_iam_policy.lb_controller_policy.arn
}
