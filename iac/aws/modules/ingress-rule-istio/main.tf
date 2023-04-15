# namespace - ingress
resource "kubernetes_namespace" "ingress_namespace" {
  metadata {
    name = "ingress"
  }
}

# ingress - to istio gateway
resource "kubernetes_ingress_v1" "apps_ingress" {
  depends_on = [
    kubernetes_namespace.ingress_namespace
  ]

  wait_for_load_balancer = true
  metadata {
    name      = "apps-ingress"
    namespace = "istio-system"
    annotations = {
      "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"      = "instance"
      "alb.ingress.kubernetes.io/certificate-arn"  = local.acm_arn
      "alb.ingress.kubernetes.io/ssl-policy"       = "ELBSecurityPolicy-2016-08"
      "alb.ingress.kubernetes.io/ssl-redirect"     = "443"
      "alb.ingress.kubernetes.io/healthcheck-path" = "/"
      "alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTP\": 80}, {\"HTTPS\":443}]"
      # 그룹명을 주어 해당그룹의 로드벨런스에 인그레스를 묶이게 한다.
      "alb.ingress.kubernetes.io/group.name" = "lake"
    }
  }

  spec {
    ingress_class_name = "alb"
    rule {
      host = local.record_feat_name
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "istio-ingressgateway"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
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
    resource.kubernetes_ingress_v1.apps_ingress
  ]

  count = length(local.record_names)

  allow_overwrite = true
  zone_id         = data.aws_route53_zone.zone_main.zone_id
  name            = local.record_names[count.index]

  type = "CNAME"
  ttl  = "300"
  records = [
    resource.kubernetes_ingress_v1.apps_ingress.status.0.load_balancer.0.ingress.0.hostname
  ]
}
