variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

provider "aws" {
  region = var.region
  # If you use a named profile, set AWS_PROFILE env var or uncomment / add profile here:
  # profile = "your-profile"
}