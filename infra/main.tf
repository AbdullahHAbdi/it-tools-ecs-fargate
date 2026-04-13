module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  tags                 = var.tags 
}

module "security_groups" {
  source = "./modules/security_groups"

  project_name   = var.project_name
  vpc_id         = module.vpc.vpc_id
  container_port = var.container_port
  tags           = var.tags
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  tags         = var.tags
}