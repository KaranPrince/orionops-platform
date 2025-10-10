output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "bastion_public_ip" {
  value = module.bastion.public_ip
}

# output "sample_app_url" {
#   value = "http://${kubernetes_service.sample-app-service.status[0].load_balancer[0].ingress[0].hostname}"
# }