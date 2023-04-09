# istio inject - argocd namespace
resource "kubernetes_namespace" "ns_argocd_inject" {
  metadata {
    labels = {
      istio-injection = "enabled"
      name            = "argocd"
    }

    name = "argocd"
  }
}

# istio inject - argo-rollouts namespace
resource "kubernetes_namespace" "ns_argo_rollouts_inject" {
  metadata {
    labels = {
      istio-injection = "enabled"
      name            = "argo-rollouts"
    }

    name = "argo-rollouts"
  }
}

resource "helm_release" "argocd" {
  depends_on = [
    resource.kubernetes_namespace.ns_argocd_inject
  ]

  create_namespace = false
  namespace        = "argocd"
  name             = "argo"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.24.1"


  values = [
    "${file("./manifest/helm-values.yaml")}"
  ]
}

# ArgoCD Rollout 설치
# 참고: https://argoproj.github.io/argo-rollouts/
resource "helm_release" "argo-rollouts" {
  depends_on = [
    helm_release.argocd
  ]

  create_namespace = true
  namespace        = "argo-rollouts"
  name             = "argo-rollouts"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-rollouts"
  version          = "2.14.0"

  set {
    name  = "dashboard.enabled"
    value = true
  }
}


