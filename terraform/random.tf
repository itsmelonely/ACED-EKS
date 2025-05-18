resource "random_id" "id" {
  byte_length = 8
}

locals {
  # This random_suffix can be used across all resources
  random_suffix = random_id.id.hex
}
