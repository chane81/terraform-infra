# tls key
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# key pair 생성
module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = local.node_key_pair_name
  public_key = trimspace(tls_private_key.key.public_key_openssh)
}

# pem export 파일
resource "local_file" "ssh_key" {
  filename = "../../../${local.node_key_pair_name}.pem"
  content  = tls_private_key.key.private_key_pem
}
