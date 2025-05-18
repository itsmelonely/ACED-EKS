output "instance_id" {
  description = "ID of the GitLab instance"
  value       = aws_instance.gitlab.id
}

output "public_ip" {
  description = "Public IP of the GitLab instance"
  value       = aws_eip.gitlab_ip.public_ip
}
