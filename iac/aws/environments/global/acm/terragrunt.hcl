include {
  path = find_in_parent_folders()
}

# local 변수
locals {
  # path
  path = "${get_terragrunt_dir()}/.."
}

# terraform source
terraform {
  source = "${get_parent_terragrunt_dir()}/modules/acm//."
}

inputs = {}
