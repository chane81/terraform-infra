# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT 설정
#
# global parameters 전달
# remote state 설정
# ---------------------------------------------------------------------------------------------------------------------

locals {
  env_path = replace(path_relative_to_include(), "environments/", "")

  region  = "ap-northeast-2"
  country = "kr"
  team    = "lake"
}

# terraform version
terraform_version_constraint = ">= 1.3.9"

# aws provider
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"

  contents = <<EOF
provider "aws" {
  region  = "${local.region}"
}
EOF
}

# remote state
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-kr-lake-state"
    key            = "envs/${local.env_path}/terraform.tfstate"
    region         = local.region
    dynamodb_table = "terraform-kr-lake-state-lock"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# global input
inputs = {
  name   = "${local.country}-${local.team}"
  region = local.region

  # tag 공통요소 (Country, Team)
  common_tag = {
    Country = local.country
    Team    = local.team
  }
}
