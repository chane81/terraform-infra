# monitoring namespace create
resource "kubernetes_namespace" "monitoring_namespace" {
  metadata {
    name = "monitoring"
  }
}

# helm - prometheus stack > prometheus, grafana
resource "helm_release" "prometheus-stack" {
  depends_on = [
    module.eks,
    kubernetes_namespace.monitoring_namespace,
    resource.kubernetes_storage_class.sc_gp3
  ]

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  name       = "prometheus"
  version    = "45.8.1"
  namespace  = "monitoring"

  values = [
    "${file("./manifest/prometheus-stack/helm-values.yml")}"
  ]
}
