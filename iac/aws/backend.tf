# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket         = "kr-partner-terraform-poc-v1"
    dynamodb_table = "kr-partner-terraform-lock-poc-v1"
    encrypt        = true
    key            = "envs/./terraform.tfstate"
    region         = "ap-southeast-1"
  }
}
