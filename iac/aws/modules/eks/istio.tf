# ---------------------------------------------------------------------------------------------------------------------
# Istio 설정
#
# Helm Chart Version 1.17.1
# ---------------------------------------------------------------------------------------------------------------------

# istio base
resource "helm_release" "istio-base" {
  depends_on = [module.eks]

  chart            = "./manifest/istio/charts/base"
  name             = "istio-base"
  namespace        = local.istio_namespace
  create_namespace = true
}

# istiod
resource "helm_release" "istiod" {
  depends_on = [helm_release.istio-base]

  chart            = "./manifest/istio/charts/istio-control/istio-discovery"
  name             = "istiod"
  namespace        = local.istio_namespace
  create_namespace = true
}

# istio ingress
resource "helm_release" "istio_ingress" {
  depends_on = [helm_release.istiod]

  chart            = "./manifest/istio/charts/gateways/istio-ingress"
  name             = "istio-ingress"
  namespace        = local.istio_namespace
  create_namespace = false

  dynamic "set" {
    for_each = {
      "gateways.istio-ingressgateway.type" = "NodePort"
    }
    content {
      name  = set.key
      value = set.value
    }
  }
}

# istio egress
resource "helm_release" "istio_egress" {
  depends_on = [helm_release.istiod]

  chart            = "./manifest/istio/charts/gateways/istio-egress"
  name             = "istio-egress"
  namespace        = local.istio_namespace
  create_namespace = false
}

# istio inject - default namespace
resource "kubernetes_labels" "ns_default_inject" {
  api_version = "v1"
  kind        = "Namespace"
  metadata {
    name = "default"
  }
  labels = {
    istio-injection = "enabled"
  }
}

# kiali
resource "helm_release" "kiali" {
  depends_on = [
    resource.helm_release.istio_ingress,
  ]

  create_namespace = true
  namespace        = local.istio_namespace
  name             = "kiali-server"
  repository       = "https://kiali.org/helm-charts"
  chart            = "kiali-server"
  version          = "1.65.0"


  dynamic "set" {
    for_each = {
      "auth.strategy"                            = "anonymous"
      "external_services.prometheus.url"         = "http://prometheus-operated.monitoring:9090/"
      "external_services.grafana.in_cluster_url" = "http://prometheus-grafana.monitoring/"
    }
    content {
      name  = set.key
      value = set.value
    }
  }
}
