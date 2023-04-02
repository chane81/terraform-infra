# 환경 - dev, staging, prod
variable "environment" {
  description = "environment - dev, staging, prod"
  type        = string

  default = "dev"
}

# name
variable "name" {
  description = "name"
  type        = string

  default = "kr-partner"
}

# eks cluster name
variable "eks_cluster_name" {
  description = "eks cluster name"
  type        = string

  default = ""
}

# tag 공통 요소
variable "common_tag" {
  description = "common tag"
  type = object({
    Country = string
    Team    = string
  })

  default = {
    Country = "kr"
    Team    = "partner"
  }
}
