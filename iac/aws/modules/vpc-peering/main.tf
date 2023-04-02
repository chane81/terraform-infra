# vpc peering
module "vpc_peering" {
  source  = "cloudposse/vpc-peering/aws"
  version = "0.10.0"

  stage            = local.environment
  name             = local.peering_name
  requestor_vpc_id = local.request_vpc_id
  acceptor_vpc_id  = local.accept_vpc_id

  tags = merge(
    {
      Name        = local.peering_name
      Environment = local.environment
    },
    var.common_tag
  )
}

# 다른 vpc 의 rds security group 인바운드에 요청자 vpc cidr 추가
resource "aws_security_group_rule" "sg_rule_rds" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [local.request_vpc_cidr]
  security_group_id = local.accept_vpc_rds_sg_id
}
