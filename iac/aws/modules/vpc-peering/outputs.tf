output "request_vpc_id" {
  description = "request vpc id"
  value       = local.request_vpc_id
}

output "accept_vpc_id" {
  description = "accept vpc id"
  value       = local.accept_vpc_id
}

output "vpc_peering_id" {
  description = "vpc peering id"
  value       = module.vpc_peering.connection_id
}
