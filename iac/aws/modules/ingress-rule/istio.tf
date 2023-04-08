# istio gateway
resource "kubernetes_manifest" "istio_gateway" {
  manifest = yamldecode(file("./manifest/istio/gateway.yaml"))
}


# istio virtual service - argocd
resource "kubernetes_manifest" "argocd_virtual_service" {
  manifest = yamldecode(file("./manifest/istio/argocd-virtual-service.yaml"))
}
