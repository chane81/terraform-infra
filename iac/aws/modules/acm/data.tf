# route53 zone - main domain
data "aws_route53_zone" "zone_main" {
  name         = local.domain
  private_zone = false
}
