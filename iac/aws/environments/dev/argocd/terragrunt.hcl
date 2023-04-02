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
  path        = "${get_terragrunt_dir()}/.."
  path_eks    = "${local.path}/eks"
  module_path = "${get_parent_terragrunt_dir()}/modules/argocd"
}

# eks - 의존관계
dependency "eks" {
  config_path = local.path_eks
}

# terraform source
terraform {
  source = "${local.module_path}//."
}

inputs = {
  environment      = local.environment
  eks_cluster_name = dependency.eks.outputs.cluster_name
}
