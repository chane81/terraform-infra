resource "random_string" "suffix" {
  length  = 4
  special = false
  lower   = true
}

locals {
  env = {
    dev = {
      ip_range_prefix = "10.10"
    }

    staging = {
      ip_range_prefix = "10.20"
    }

    prod = {
      ip_range_prefix = "10.30"
    }
  }

  postfix     = random_string.suffix.result
  environment = var.environment

  # name
  name                = var.name
  vpc_name            = "${local.name}-vpc-${local.postfix}-${local.environment}"
  public_subnet_name  = "${local.name}-subnet-public-${local.postfix}-${local.environment}"
  private_subnet_name = "${local.name}-subnet-private-${local.postfix}-${local.environment}"

  # ip range prefix, ex) 10.10
  ip_range_prefix = local.env[local.environment].ip_range_prefix
}

