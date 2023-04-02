# metrics server 설치
resource "helm_release" "metrics-server" {
  depends_on = [
    module.eks
  ]

  name = "metrics-server"

  repository = "https://kubernetes-sigs.github.io/metrics-server"
  chart      = "metrics-server"
  version    = "3.8.4"
  namespace  = "kube-system"

  set {
    name  = "args[0]"
    value = "--kubelet-insecure-tls"
  }
}
