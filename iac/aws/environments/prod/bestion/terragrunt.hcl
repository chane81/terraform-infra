include {
  path = find_in_parent_folders()
}

# local 변수
locals {
  # load env 파일
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # dev/staging/prod
  environment = local.environment_vars.locals.environment

  # path
  path     = "${get_terragrunt_dir()}/.."
  path_vpc = "${local.path}/vpc"
}

# 의존관계
dependency "vpc" {
  config_path = local.path_vpc
}

# terraform source
terraform {
  source = "${get_parent_terragrunt_dir()}/modules/bestion//."
}

inputs = {
  environment    = local.environment
  vpc_id         = dependency.vpc.outputs.vpc_id
  postfix        = dependency.vpc.outputs.postfix
  public_subnets = dependency.vpc.outputs.vpc_public_subnets
}
