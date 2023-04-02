output "environment" {
  description = "environment - dev/staging/prod"
  value       = local.environment
}

output "postfix" {
  description = "postfix"
  value       = local.postfix
}

output "ip_range_prefix" {
  description = "ip range prefix"
  value       = local.ip_range_prefix
}

output "vpc_name" {
  description = "vpc name"
  value       = local.vpc_name
}

output "vpc_id" {
  description = "vpc id"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "vpc cidr"
  value       = module.vpc.vpc_cidr_block
}

output "vpc_public_subnets" {
  description = "pulbic subnet"
  value       = module.vpc.public_subnets
}

output "vpc_private_subnets" {
  description = "pulbic subnet"
  value       = module.vpc.private_subnets
}

# public subnet arns
output "vpc_public_subnet_arns" {
  description = "pulbic subnet arns"
  value       = module.vpc.public_subnet_arns
}

# private subnet arns
output "vpc_private_subnet_arns" {
  description = "private subnet arns"
  value       = module.vpc.private_subnet_arns
}

