output "ecr_repository_url" {
  description = "ecr repository url"  
  value       = aws_ecr_repository.main.repository_url
}

output "repository_arn" {
  description = "ecr repository arn"
  value       = aws_ecr_repository.main.arn
}

output "repository_name" {
  description = "ecr repository name"
  value       = aws_ecr_repository.main.name
  
}