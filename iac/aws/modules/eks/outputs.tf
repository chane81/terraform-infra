output "region" {
  description = "region"
  value       = local.region
}

output "environment" {
  description = "environment - dev/staging/prod"
  value       = local.environment
}

output "cluster_name" {
  description = "cluster name"
  value       = local.eks_cluster_name
}

output "cluster_arn" {
  description = "cluster arn"
  value       = module.eks.cluster_arn
}

output "cluster_iam_role_name" {
  description = "cluster iam role name"
  value       = module.eks.cluster_iam_role_name
}

output "cluster_iam_role_arn" {
  description = "cluster iam role arn"
  value       = module.eks.cluster_iam_role_arn
}

output "cluster_endpoint" {
  description = "cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "cluster security-group-id"
  value       = module.eks.cluster_security_group_id
}

output "config_map_aws_auth" {
  description = "A kubernetes configuration to authenticate to this EKS cluster."
  value       = module.eks.aws_auth_configmap_yaml
}

output "node_groups" {
  description = "eks-managed node-groups"
  value       = module.eks.eks_managed_node_groups
}
