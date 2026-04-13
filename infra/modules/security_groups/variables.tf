variable "vpc_id" {
  description = "vpc id to attach security groups to"
  type        = string
}

variable "project_name" {
  description = "project name for resource"
  type        = string
}

variable "container_port" {
  description = "port the container listens on"
  type        = number
}

variable "tags" {
  description = "common tags for resources in this module"
  type        = map(string)
}

variable "alb_ingress_rules" {
  description = "ingress rules for alb security group"
  type        = list(object({
    port        = number
    cidr_blocks = list(string)
  }))
  default = [
    { port = 80, cidr_blocks = ["0.0.0.0/0"] },
    { port = 443, cidr_blocks = ["0.0.0.0/0"] }
  ]
}


