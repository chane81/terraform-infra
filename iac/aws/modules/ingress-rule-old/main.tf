# argocd 인그레스 생성
resource "kubernetes_manifest" "argocd_manifest" {
  manifest = yamldecode(templatefile("./manifest/argocd/${local.environment}.ingress-rule.yaml.tftpl", {
    acm_arn     = local.acm_arn
    argocd_host = replace(local.record_feat_name, "*", "argocd")
    istio_host  = replace(local.record_feat_name, "*", "istio")
  }))

  wait {
    fields = {
      "status.loadBalancer.ingress[0].hostname" = "*"
    }
  }

  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
}

# route 53 record
# *.dev.partner.gomicorp.click
# *.staging.partner.gomicorp.click
# *.partner.gomicorp.click
resource "aws_route53_record" "record_feat" {
  depends_on = [
    resource.kubernetes_manifest.argocd_manifest
  ]

  allow_overwrite = true
  zone_id         = data.aws_route53_zone.zone_main.zone_id
  name            = local.record_feat_name

  type = "CNAME"
  ttl  = "300"
  records = [
    data.kubernetes_ingress_v1.argocd_ingress.status.0.load_balancer.0.ingress.0.hostname,
  ]
}

# route 53 record
# dev.partner.gomicorp.click
# staging.partner.gomicorp.click
# partner.gomicorp.click
resource "aws_route53_record" "record_base" {
  depends_on = [
    resource.kubernetes_manifest.argocd_manifest
  ]

  allow_overwrite = true
  zone_id         = data.aws_route53_zone.zone_main.zone_id
  name            = local.record_base_name

  type = "CNAME"
  ttl  = "300"
  records = [
    data.kubernetes_ingress_v1.argocd_ingress.status.0.load_balancer.0.ingress.0.hostname,
  ]
}
