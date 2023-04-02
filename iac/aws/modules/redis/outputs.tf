output "redis_arn" {
  description = "redis arn"
  value       = resource.aws_elasticache_cluster.redis.arn
}

output "redis_url" {
  description = "redis url"
  value       = resource.aws_elasticache_cluster.redis.cache_nodes[0].address
}
