# output "argocd_hosts" {
#   description = "argocd ingress hosts"
#   value       = one([for v in data.kubernetes_ingress_v1.argocd_ingress.spec[0].rule : v.host])
# }
