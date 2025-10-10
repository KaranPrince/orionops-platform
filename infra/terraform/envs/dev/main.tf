# -------------------------------
# Terraform Block - FIXED PROVIDER VERSION
# -------------------------------
terraform {
  required_version = ">= 1.8.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
    kubernetes = {                     # 👈 Added explicitly (best practice)
      source  = "hashicorp/kubernetes"
      version = "~> 2.29"              # 👈 Use any 2.x stable version
    }
  }
}

# -------------------------------
# Provider Configuration
# -------------------------------
provider "aws" {
  region = "us-east-1"
}

# -------------------------------
# Local Variables
# -------------------------------
locals {
  project     = "orionops"
  environment = "dev"

  tags = {
    Project     = local.project
    Environment = local.environment
    ManagedBy   = "Terraform"
  }
}

# -------------------------------
# VPC Module
# -------------------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = "${local.project}-vpc-${local.environment}"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.tags
}

# -------------------------------
# EKS Cluster - (v19.x syntax)
# -------------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.20"

  cluster_name    = "${local.project}-eks-${local.environment}"
  cluster_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access       = true
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  manage_aws_auth_configmap = true   # ✅ Terraform will now manage aws-auth

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::576290270995:user/AdminUser"
      username = "admin"
      groups   = ["system:masters"]
    }
  ]

  eks_managed_node_groups = {
    default = {
      name           = "${local.project}-${local.environment}-ng"
      desired_size   = 2
      min_size       = 1
      max_size       = 3
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = local.tags
}

# -------------------------------
# Bastion Host Module
# -------------------------------
module "bastion" {
  source = "../../modules/bastion"

  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnets[0]
  key_name      = var.bastion_key_name
  instance_type = "t3.micro"
  project       = local.project
  environment   = local.environment
  common_tags   = local.tags
}

# # -------------------------------
# # EKS Cluster Data Sources
# # -------------------------------
# data "aws_eks_cluster" "this" {
#   name = module.eks.cluster_name

#   depends_on = [
#     module.eks
#   ]
# }

# data "aws_eks_cluster_auth" "this" {
#   name = module.eks.cluster_name

#   depends_on = [
#     module.eks
#   ]
# }


# # -------------------------------
# # Kubernetes Provider
# # -------------------------------
# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.this.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.this.token
# }
