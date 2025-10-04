variable "env" {
  description = "Environment (dev/stage/prod)"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name used for tags"
  type        = string
  default     = "orionops"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "orionops-eks-dev"
}

variable "kubernetes_version" {
  description = "Kubernetes control-plane version for EKS"
  type        = string
  # ✅ AWS supports 1.29, 1.30, 1.31 as of Sept 2025.
  default = "1.30"
}

variable "bastion_allowed_cidr" {
  description = "CIDR allowed to SSH to bastion. Leave empty to rely on SSM only."
  type        = string
  # ⚠️ Replace with your own IP before production.
  default = "0.0.0.0/0"
}

variable "bastion_key_name" {
  description = "Optional EC2 keypair name to attach to bastion (or empty)"
  type        = string
  default     = "virginia-key-pair" # must exist in AWS EC2 Key Pairs
}

variable "node_group_instance_types" {
  description = "EC2 instance types for worker nodes"
  type        = list(string)
  default     = ["t3.large"]
}

variable "node_group_min" {
  type    = number
  default = 1
}

variable "node_group_desired" {
  type    = number
  default = 2
}

variable "node_group_max" {
  type    = number
  default = 3
}
