output "eks_cluster_role_arn" {
  description = "ARN of the EKS Cluster IAM Role"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  description = "ARN of the EKS Node IAM Role"
  value       = aws_iam_role.eks_node_role.arn
}

output "gitlab_role_arn" {
  description = "ARN of the GitLab IAM Role"
  value       = aws_iam_role.gitlab_role.arn
}

output "gitlab_instance_profile_name" {
  description = "Name of the GitLab Instance Profile"
  value       = aws_iam_instance_profile.gitlab_instance_profile.name
}

output "gitlab_instance_profile_arn" {
  description = "ARN of the GitLab Instance Profile"
  value       = aws_iam_instance_profile.gitlab_instance_profile.arn
}
