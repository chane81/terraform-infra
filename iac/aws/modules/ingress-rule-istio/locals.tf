locals {
  environment = var.environment
  domain      = "mosaicsquare.link"
  team_domain = "lake.${local.domain}"

  # name
  eks_name         = var.eks_cluster_name
  record_feat_name = "*${local.environment == "prod" ? "" : ".${local.environment}"}.${local.team_domain}"
  record_base_name = "${local.environment == "prod" ? "" : "${local.environment}."}${local.team_domain}"
  record_names = [
    local.record_feat_name,
    local.record_base_name
  ]

  # acm arn
  acm_arn = var.acm_arn

  # global-accelerator name
  accelerator_name = "${var.name}-accelerator-${var.postfix}-${var.environment}"

  # hosts
  # hosts = {
  #   argocd  = "argocd.${local.record_base_name}"
  #   grafana = "grafana.${local.record_base_name}"
  # }
  host_target = [
    "argocd",
    "grafana"
  ]
}
