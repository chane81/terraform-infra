locals {
  environment = var.environment

  # name
  key_pair_name       = "${var.name}-kp-${var.postfix}-${var.environment}"
  ec2_bestion_name    = "${var.name}-bestion-${var.postfix}-${var.environment}"
  security_group_name = "${var.name}-sgp-${var.postfix}-${var.environment}"

  # vpc id
  vpc_id = var.vpc_id

  # public subnet ids
  public_subnets = var.public_subnets

  # ec2 ami
  ami = "ami-0f2eac25772cd4e36"
}
