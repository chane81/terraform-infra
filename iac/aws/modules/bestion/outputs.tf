output "bestion_arn" {
  description = "bestion arn"
  value       = resource.aws_instance.bestion.arn
}

output "bestion_public_dns" {
  description = "bestion public dns"
  value       = resource.aws_instance.bestion.public_dns
}

output "bestion_name" {
  description = "bestion name"
  value       = local.ec2_bestion_name
}

output "key_pair_name" {
  description = "key pair name"
  value       = module.key_pair.key_pair_name
}
