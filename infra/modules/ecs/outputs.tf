output "cluster_id" {
  description = "ecs cluster id"
  value       = aws_ecs_cluster.main.id
}

output "cluster_name" {
  description = "ecs cluster name"
  value       = aws_ecs_cluster.main.name
}

output "cluster_arn" {
  description = "ecs cluster arn"
  value       = aws_ecs_cluster.main.arn
}

output "service_id" {
  description = "ecs service id"
  value       = aws_ecs_service.main.id
}

output "service_name" {
  description = "ecs service name"
  value       = aws_ecs_service.main.name
}

output "task_definition_arn" {
  description = "task definition arn"
  value       = aws_ecs_task_definition.service.arn
}

output "log_group_name" {
  description = "cloudwatch log group name"
  value       = aws_cloudwatch_log_group.main.name
}