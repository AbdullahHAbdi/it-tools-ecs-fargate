variable "project_name" {
  description = "project name for resource"
  type        = string
}

variable "tags" {
  description = "common tags for resources in this module"
  type        = map(string)
}