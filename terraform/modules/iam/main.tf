# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role-${var.random_suffix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "eks-cluster-role-${var.random_suffix}"
  }
}

# Attach the AmazonEKSClusterPolicy to the EKS Cluster Role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
  
  depends_on = [aws_iam_role.eks_cluster_role]
}

# IAM Role for EKS Node Group
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role-${var.random_suffix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "eks-node-role-${var.random_suffix}"
  }
}

# Attach the required policies to the EKS Node Role
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
  
  depends_on = [aws_iam_role.eks_node_role]
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
  
  depends_on = [aws_iam_role.eks_node_role]
}

resource "aws_iam_role_policy_attachment" "ecr_pull_only_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
  
  depends_on = [aws_iam_role.eks_node_role]
}

# IAM Role for GitLab Instance
resource "aws_iam_role" "gitlab_role" {
  name = "gitlab-role-${var.random_suffix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "gitlab-role-${var.random_suffix}"
  }
}

# Create a policy that allows all EKS actions
resource "aws_iam_policy" "gitlab_eks_policy" {
  name        = "gitlab-eks-policy-${var.random_suffix}"
  description = "Policy that allows GitLab to manage EKS clusters"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "eks:*"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Attach the EKS policy to the GitLab role
resource "aws_iam_role_policy_attachment" "gitlab_eks_policy_attachment" {
  policy_arn = aws_iam_policy.gitlab_eks_policy.arn
  role       = aws_iam_role.gitlab_role.name
  
  depends_on = [aws_iam_role.gitlab_role, aws_iam_policy.gitlab_eks_policy]
}

# Create an instance profile for the GitLab role
resource "aws_iam_instance_profile" "gitlab_instance_profile" {
  name = "gitlab-instance-profile-${var.random_suffix}"
  role = aws_iam_role.gitlab_role.name
  
  depends_on = [aws_iam_role.gitlab_role, aws_iam_policy.gitlab_eks_policy]
}
