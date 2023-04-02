# request vpc
data "aws_vpc" "request_vpc" {
  id = var.vpc_id
}

# accept vpc
data "aws_vpc" "accept_vpc" {
  id = local.accept_vpc_id
}

