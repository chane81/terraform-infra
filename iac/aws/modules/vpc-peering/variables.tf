# 환경 - dev, staging, prod
variable "environment" {
  description = "environment - dev, staging, prod"
  type        = string

  default = "dev"
}

# postfix
variable "postfix" {
  description = "postfix"
  type        = string
}

# name
variable "name" {
  description = "name"
  type        = string

  default = "kr-lake"
}

# vpc id
variable "vpc_id" {
  description = "vpc id"
  type        = string
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
    Team    = "lake"
  }
}
