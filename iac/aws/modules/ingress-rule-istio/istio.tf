# istio gateway
resource "kubernetes_manifest" "istio_gateway" {
  manifest = yamldecode(file("./manifest/istio/gateway.yaml"))
}

# istio virtual service
# [target]-virtual-service.yaml.tfpl 파일을 count 로 순회하여 실행
resource "kubernetes_manifest" "virtual_service" {
  count = length(local.host_target)

  manifest = yamldecode(templatefile("./manifest/istio/${local.host_target[count.index]}-virtual-service.yaml.tftpl", {
    host = "${local.host_target[count.index]}.${local.record_base_name}"
  }))
}
