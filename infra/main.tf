# terraform infrastructure for it tools ecs deployment on aws fargate

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

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  tags         = var.tags
}

module "alb" {
  source = "./modules/alb"

  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security_groups.alb_security_group_id
  certificate_arn       = module.acm.certificate_arn
  container_port        = var.container_port
  tags                  = var.tags
}

module "route53" {
  source = "./modules/route53"

  project_name = var.project_name
  domain_name  = var.domain_name
  subdomain    = var.subdomain
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
  tags         = var.tags
}

module "acm" {
  source = "./modules/acm"

  project_name    = var.project_name
  domain_name     = var.domain_name
  subdomain       = var.subdomain
  route53_zone_id = module.route53.zone_id
  tags            = var.tags
}

module "ecs" {
  source = "./modules/ecs"

  project_name          = var.project_name
  aws_region            = var.aws_region
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  ecs_security_group_id = module.security_groups.ecs_security_group_id
  target_group_arn      = module.alb.target_group_arn
  execution_role_arn    = module.iam.execution_role_arn
  task_role_arn         = module.iam.task_role_arn
  ecr_repository_url    = module.ecr.ecr_repository_url
  container_port        = var.container_port
  task_cpu              = var.task_cpu
  task_memory           = var.task_memory
  desired_count         = var.desired_count
  tags                  = var.tags
}