locals {
  environment    = var.environment
  domain         = "gomicorp.click"
  partner_domain = "partner.${local.domain}"
}
