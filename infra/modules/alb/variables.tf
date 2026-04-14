variable "project_name" {
  description = "project name for resource"
  type        = string
}

variable "vpc_id" {
  description = "vpc id to attach security groups to"
  type        = string
}

variable "container_port" {
  description = "port the container listens on"
  type        = number
}

variable "public_subnet_ids" {
  description = "list of public subnet ids for alb"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "security group id for alb"
  type        = string
}

variable "certificate_arn" {
  description = "arn of acm certificate for https listener"
  type        = string
}

variable "tags" {
  description = "common tags for resources in this module"
  type        = map(string)
}