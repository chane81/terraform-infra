locals {
  environment    = var.environment
  domain         = "gomicorp.click"
  partner_domain = "partner.${local.domain}"

  # name
  eks_name         = var.eks_cluster_name
  record_feat_name = "*${local.environment == "prod" ? "" : ".${local.environment}"}.${local.partner_domain}"
  record_base_name = "${local.environment == "prod" ? "" : "${local.environment}."}${local.partner_domain}"

  # alb arn
  # alb_arn = one(data.aws_lbs.alb.arns)

  # acm arn
  acm_arn = "arn:aws:acm:ap-southeast-1:580214777026:certificate/58b2aed0-8a54-426f-99f3-650994be9d87"

  # global-accelerator name
  accelerator_name = "${var.name}-accelerator-${var.postfix}-${var.environment}"
}
