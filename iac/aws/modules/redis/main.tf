
# security group - redis
resource "aws_security_group" "sgp-redis" {
  name   = local.security_group_name
  vpc_id = var.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name        = local.security_group_name
      Environment = local.environment
    },
    var.common_tag
  )
}

# redis subnet group
resource "aws_elasticache_subnet_group" "subnet_group_redis" {
  name       = local.subnet_group_name
  subnet_ids = slice(local.private_subnets, 0, 2)
}

# redis (aws elastiCache)
resource "aws_elasticache_cluster" "redis" {
  depends_on = [
    aws_security_group.sgp-redis
  ]

  cluster_id           = local.redis_name
  engine               = "redis"
  node_type            = "cache.t2.small"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.2"
  port                 = 6379
  subnet_group_name    = resource.aws_elasticache_subnet_group.subnet_group_redis.name
  security_group_ids   = [resource.aws_security_group.sgp-redis.id]

  tags = merge(
    {
      Name        = local.redis_name
      Environment = local.environment
    },
    var.common_tag
  )
}

