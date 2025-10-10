terraform {
  backend "s3" {
    bucket         = "orionops-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "orionops-terraform-locks"
    encrypt        = true
  }
}
