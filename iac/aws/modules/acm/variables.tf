# tag 공통 요소
variable "common_tag" {
  description = "common tag"
  type = object({
    Country = string
    Team    = string
  })

  default = {
    Country = "kr"
    Team    = "team"
  }
}
