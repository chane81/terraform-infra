# argocd 인그레스 생성
resource "kubernetes_manifest" "ingress_manifest" {
  count = length(local.ingress_configs)

  manifest = yamldecode(templatefile("./manifest/ingress-rule.yaml.tftpl", {
    acm_arn   = local.acm_arn
    namespace = local.ingress_configs[count.index].namespace
    name      = local.ingress_configs[count.index].name
    host      = local.ingress_configs[count.index].host
    service   = local.ingress_configs[count.index].service
    port      = local.ingress_configs[count.index].port
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
# [dev]
# *.dev.lake.mosaicsquare.link
# dev.lake.mosaicsquare.link
#
# [staging]
# *.staging.lake.mosaicsquare.link
# staging.lake.mosaicsquare.link
#
# [prod]
# *.lake.mosaicsquare.link
# lake.mosaicsquare.link
resource "aws_route53_record" "record_feat" {
  depends_on = [
    resource.kubernetes_manifest.ingress_manifest
  ]

  count = length(local.record_names)

  allow_overwrite = true
  zone_id         = data.aws_route53_zone.zone_main.zone_id
  name            = local.record_names[count.index]

  type = "CNAME"
  ttl  = "300"
  records = [
    data.kubernetes_ingress_v1.ingress.status.0.load_balancer.0.ingress.0.hostname,
  ]
}
