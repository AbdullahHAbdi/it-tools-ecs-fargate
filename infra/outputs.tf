output "project_name" {
  description = "project name used for resource naming"
  value       = var.project_name
}

output "vpc_id" {
  description = "id of the vpc"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "dns name of the load balancer"
  value       = module.alb.alb_dns_name
}

output "application_url" {
  description = "application url"
  value       = "https://${var.subdomain}.${var.domain_name}"
}

output "name_servers" {
  description = "route 53 name servers - add these to Cloudflare"
  value       = module.route53.name_servers
}

output "ecs_cluster_name" {
  description = "ecs cluster name"
  value       = module.ecs.cluster_name
}

output "certificate_arn" {
  description = "arn of the validated ACM certificate"
  value       = module.acm.certificate_arn
}
