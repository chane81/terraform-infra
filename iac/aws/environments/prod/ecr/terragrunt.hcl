include {
  path = find_in_parent_folders()
}

# local 변수
locals {
  # load env 파일
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # dev/staging/prod
  environment = local.environment_vars.locals.environment
}

# terraform source
terraform {
  source = "${get_parent_terragrunt_dir()}/modules/ecr//."
}

inputs = {
  environment = local.environment
}
