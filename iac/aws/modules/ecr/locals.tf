locals {
  env = {
    dev = {
      ecr_name = [
        "${var.name}-api-${var.environment}",
        "${var.name}-admin-web-${var.environment}",
        "${var.name}-client-web-${var.environment}",
        "${var.name}-unit-${var.environment}",
      ]
    }

    staging = {
      ecr_name = [
        "${var.name}-api-${var.environment}",
        "${var.name}-admin-web-${var.environment}",
        "${var.name}-client-web-${var.environment}",
      ]
    }

    prod = {
      ecr_name = [
        "${var.name}-api-${var.environment}",
        "${var.name}-admin-web-${var.environment}",
        "${var.name}-client-web-${var.environment}",
      ]
    }
  }

  environment = var.environment

  # kr-partner-{이름}-{환경}
  # ex) kr-partner-api-dev
  ecr_name = local.env[var.environment].ecr_name
}
