terraform {
  required_providers {
    aws        = ">= 4.55.0"
    local      = ">= 2.3.0"
    kubernetes = ">= 2.18.1"
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }
}
