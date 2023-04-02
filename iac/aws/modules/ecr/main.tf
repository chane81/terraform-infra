# ecr
resource "aws_ecr_repository" "ecr_partner" {
  for_each             = toset(local.ecr_name)
  name                 = each.key
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = false
  }
}
