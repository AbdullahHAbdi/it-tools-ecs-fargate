output "alb_dns_name" {
  description = "dns name of the load balancer"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "arn of the load balancer"
  value       = aws_lb.main.arn
}

output "target_group_arn" {
  description = "arn of the target group"
  value       = aws_lb_target_group.main.arn
}

output "alb_zone_id" {
  description = "zone id of the load balancer for route53 alias"
  value       = aws_lb.main.zone_id
}