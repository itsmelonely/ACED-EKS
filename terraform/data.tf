data "aws_key_pair" "main" {
  key_name           = var.key_name
  include_public_key = true
}