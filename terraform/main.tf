provider aws {
  region = var.region
  skip_region_validation = true
}

module "networking" {
  source            = "./modules/networking"
  vpc_cidr          = var.vpc_cidr
  public_subnetcidr = var.public_gitlabcidr
  random_suffix     = local.random_suffix
  eks_cluster_name  = var.eks_cluster_name
  eks_subnet_cidr_1 = var.eks_subnet_cidr_1
  eks_subnet_cidr_2 = var.eks_subnet_cidr_2
  eks_subnet_cidr_3 = var.eks_subnet_cidr_3
}

module "security" {
  source        = "./modules/security"
  vpc_id        = module.networking.vpc_id
  random_suffix = local.random_suffix
}

module "iam" {
  source        = "./modules/iam"
  random_suffix = local.random_suffix
}

module "gitlab" {
  source              = "./modules/gitlab"
  ami_id              = "ami-004b08264d791b77c" # Updated GitLab AMI
  instance_type       = var.gitlab_instance_type
  key_name            = data.aws_key_pair.main.key_name
  subnet_id           = module.networking.public_subnet_id
  security_group_id   = module.security.security_group_id
  root_volume_size    = var.root_volume_size
  random_suffix       = local.random_suffix
  iam_instance_profile = module.iam.gitlab_instance_profile_name
}

module "ecr" {
  source        = "./modules/ecr"
  ecr_name      = var.ecr_name
  random_suffix = local.random_suffix
}

module "eks" {
  source              = "./modules/eks"
  eks_cluster_name    = var.eks_cluster_name
  random_suffix       = local.random_suffix
  vpc_id              = module.networking.vpc_id
  subnet_ids          = module.networking.eks_subnet_ids
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_role_arn   = module.iam.eks_node_role_arn
  nodegroup_instance_type = var.nodegroup_instance_type
  key_name            = data.aws_key_pair.main.key_name
}
