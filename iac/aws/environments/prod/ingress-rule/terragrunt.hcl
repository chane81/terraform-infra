include {
  path = find_in_parent_folders()
}

# local 변수
locals {
  # load env 파일
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # dev/staging/prod
  environment = local.environment_vars.locals.environment

  path        = "${get_parent_terragrunt_dir()}/environments/${local.environment}"
  path_eks    = "${local.path}/eks"
  path_vpc    = "${local.path}/vpc"
  path_argocd = "${local.path}/argocd"
}

# eks, argocd 의존관계
dependencies {
  paths = [
    local.path_vpc,
    local.path_eks,
    local.path_argocd
  ]
}

# 의존관계
dependency "vpc" {
  config_path = local.path_vpc
}

# eks - 의존관계
dependency "eks" {
  config_path = local.path_eks
}

# terraform source
terraform {
  source = "${get_parent_terragrunt_dir()}/modules/ingress-rule//."
}

inputs = {
  environment    = local.environment
  eks_cluster_id = dependency.eks.outputs.cluster_id
  postfix        = dependency.vpc.outputs.postfix
}
