# .terragrunt-cache, .terraform.lock.hcl 삭제
find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;
find . -type f -name ".terraform.lock.hcl" -prune -exec rm -rf {} \;