# acm 인증서 생성
resource "aws_acm_certificate" "cert" {
  domain_name = local.team_domain
  subject_alternative_names = [
    "*.dev.${local.team_domain}",
    "*.staging.${local.team_domain}",
    "*.${local.team_domain}",
    "${local.team_domain}"
  ]
  validation_method = "DNS"

  tags = merge(
    var.common_tag
  )

  lifecycle {
    create_before_destroy = true
  }
}

# 생성한 acm 을 route53 record 에 등록
resource "aws_route53_record" "record_acm" {
  depends_on = [
    aws_acm_certificate.cert
  ]

  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone_main.zone_id
}
