resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# key pair 생성
module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = local.key_pair_name
  public_key = trimspace(tls_private_key.key.public_key_openssh)
}

# pem export 파일
resource "local_file" "ssh_key" {
  filename = "../../../${local.key_pair_name}.pem"
  content  = tls_private_key.key.private_key_pem
}

# security group - bastion
resource "aws_security_group" "sgp_bestion" {
  name   = local.security_group_name
  vpc_id = local.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # DB 접속
  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }

  tags = {
    "Name"        = local.security_group_name
    "Environment" = local.environment
  }
}

# bestion 인스턴스
resource "aws_instance" "bestion" {
  depends_on = [resource.aws_security_group.sgp-bestion]

  ami           = local.ami
  instance_type = "t2.micro"

  subnet_id = element(local.public_subnets, 3)
  key_name  = module.key_pair.key_pair_name
  vpc_security_group_ids = [
    resource.aws_security_group.sgp-bestion.id
  ]
  associate_public_ip_address = true

  tags = merge(
    {
      # tags 의 "Name"을 따라 ec2 인스턴스 이름도 동일하게 생성 되므로 참고할 것
      Name        = local.ec2_bestion_name
      Environment = local.environment
    },
    var.common_tag
  )
}
