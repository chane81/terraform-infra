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

# postfix
variable "postfix" {
  description = "postfix"
  type        = string
}

# vpc id
variable "vpc_id" {
  description = "vpc id"
  type        = string
}

# public subnets
variable "public_subnets" {
  description = "public subnets"
  type        = list(string)
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
