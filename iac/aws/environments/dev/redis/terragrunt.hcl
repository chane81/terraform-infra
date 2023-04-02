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
  path = "${get_terragrunt_dir()}/.."
}

# 의존관계
dependency "vpc" {
  config_path = "${local.path}/vpc"
}

# terraform source
terraform {
  source = "${get_parent_terragrunt_dir()}/modules/redis//."
}

inputs = {
  environment     = local.environment
  vpc_id          = dependency.vpc.outputs.vpc_id
  private_subnets = dependency.vpc.outputs.vpc_private_subnets
  postfix         = dependency.vpc.outputs.postfix
}
