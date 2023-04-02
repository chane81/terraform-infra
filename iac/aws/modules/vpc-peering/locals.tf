locals {
  env = {
    dev = {
      accept_vpc_id        = "vpc-02d7921512ed404cf"
      accept_vpc_rds_sg_id = "sg-04c3c4a35cd5d852f"
    }

    staging = {
      accept_vpc_id        = "vpc-02d7921512ed404cf"
      accept_vpc_rds_sg_id = "sg-04c3c4a35cd5d852f"
    }

    prod = {
      accept_vpc_id        = "vpc-02d7921512ed404cf"
      accept_vpc_rds_sg_id = "sg-04c3c4a35cd5d852f"
    }
  }

  environment = var.environment

  # name
  peering_name = "${var.name}-peering-${var.postfix}-${var.environment}"

  # 요청자 vpc - eks가 있는 vpc
  request_vpc      = data.aws_vpc.request_vpc
  request_vpc_id   = data.aws_vpc.request_vpc.id
  request_vpc_cidr = data.aws_vpc.request_vpc.cidr_block

  # 수락자 vpc - db가 있는 vpc
  accept_vpc_id   = local.env[var.environment].accept_vpc_id
  accept_vpc      = data.aws_vpc.accept_vpc
  accept_vpc_cidr = data.aws_vpc.accept_vpc.cidr_block

  # 연결할 db 의 security group id
  accept_vpc_rds_sg_id = local.env[var.environment].accept_vpc_rds_sg_id
}
