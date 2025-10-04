variable "repository_name" {
  type        = string
  description = "Name for the ECR repository"
}

variable "tags" {
  type    = map(string)
  default = {}
}