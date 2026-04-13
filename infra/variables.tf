variable "aws_region" {
  description = "aws region used to create all resources"
  type        = string
  default     = "us-east-2"
}

variable "tags" {
  description = "common tags for all resources"
  type        = map(string)
  default = {
    Project     = "it-tools"
    ManagedBy   = "terraform"
    Environment = "prod"
  }
}

variable "project_name" {
  description = "project name used for resource naming"
  type        = string
  default     = "it-tools"
}

variable "vpc_cidr" {
  description = "cidr block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
    description = "list of availability zones"
    type = list(string)
    default = [ "us-east-2a", "us-east-2b" ]
}

variable "public_subnet_cidrs" {
    description = "cidr blocks for public subnets"
    type = list(string)
    default = [ "10.0.0.0/24","10.0.1.0/24" ]
}

variable "private_subnet_cidrs" {
    description = "cidr blocks for private subnets"
    type = list(string)
    default = [ "10.0.2.0/24","10.0.3.0/24" ]
}

variable "container_port" {
  description = "port the container listens on"
  type        = number
  default     = 8080
}