locals {
  environment = var.environment

  # private subnet ids
  private_subnets = var.private_subnets

  # name
  redis_name          = "${var.name}-redis-${var.environment}"
  subnet_group_name   = "${var.name}-sg-redis-${var.postfix}-${var.environment}"
  security_group_name = "${var.name}-sgp-redis-${var.postfix}-${var.environment}"
}
