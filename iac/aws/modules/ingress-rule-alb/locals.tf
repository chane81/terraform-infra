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

  # alb arn
  alb_arn = one(data.aws_lbs.alb.arns)

  # acm arn
  acm_arn = var.acm_arn

  ingress_configs = [
    {
      name      = "argocd"
      namespace = "argocd"
      host      = replace(local.record_feat_name, "*", "argocd")
      service   = "argo-argocd-server"
      port      = 80
    },
    {
      name      = "grafana"
      namespace = "monitoring"
      host      = replace(local.record_feat_name, "*", "grafana")
      service   = "prometheus-grafana"
      port      = 80
    }
  ]
}
