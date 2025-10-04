locals {
  project = var.project
}

# Availability Zones
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC (terraform-aws-modules/vpc/aws)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  name = "${local.project}-${var.env}-vpc"
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true

  tags = {
    Project     = local.project
    Environment = var.env
  }
}

# ECR (local module)
module "ecr" {
  source          = "../../modules/ecr"
  repository_name = "${lower(local.project)}-node-service"

  tags = {
    Project     = local.project
    Environment = var.env
  }
}

# EKS (terraform-aws-modules/eks/aws)
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  endpoint_public_access                   = true
  endpoint_private_access                  = true
  enable_cluster_creator_admin_permissions = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      name           = "${local.project}-${var.env}-ng"
      instance_types = var.node_group_instance_types
      desired_size   = var.node_group_desired
      min_size       = var.node_group_min
      max_size       = var.node_group_max
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = {
    Project     = local.project
    Environment = var.env
  }
}

# Bastion (local module)
module "bastion" {
  source      = "../../modules/bastion"
  name_prefix = "${local.project}-${var.env}-bastion"

  vpc_id           = module.vpc.vpc_id
  public_subnet_id = element(module.vpc.public_subnets, 0)
  region           = var.region
  allowed_ssh_cidr = var.bastion_allowed_cidr
  key_pair_name    = var.bastion_key_name
  instance_type    = "t3.nano"

  tags = {
    Project     = local.project
    Environment = var.env
  }
}
