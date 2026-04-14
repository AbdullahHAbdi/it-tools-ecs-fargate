variable "project_name" {
  description = "project name for resource"
  type        = string
}

variable "aws_region" {
  description = "aws region used to create all resources"
  type        = string
}

variable "vpc_id" {
  description = "vpc id to attach security groups to"
  type        = string
}

variable "private_subnet_ids" {
  description = "list of ids of the private subnets"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "ecs security group ID"
  type        = string
}

variable "target_group_arn" {
  description = "arn of the target group"
  type        = string
}

variable "task_role_arn" {
  description = "arn of ecs task role"
  type        = string
}

variable "execution_role_arn" {
  description = "arn of ecs execution role"
  type        = string
}

variable "ecr_repository_url" {
  description = "ecr repository url"  
  type        = string
}

variable "container_port" {
  description = "port the container listens on"
  type        = number
}

variable "desired_count" {
  description = "number of ecs tasks to run"
  type        = number
}

variable "task_cpu" {
  description = "cpu amount for tasks"
  type        = string
}

variable "task_memory" {
  description = "memory amount for tasks"
  type        = string
}

variable "tags" {
  description = "common tags for resources in this module"
  type        = map(string)
}