# policy 생성
resource "aws_iam_policy" "iam_policy_autoscaling" {
  name        = local.policy_autocaling_name
  path        = "/"
  description = "Autoscaling policy for cluster"

  policy = data.aws_iam_policy_document.worker_autoscaling.json
}

# iam role 에 policy attach 작업
resource "aws_iam_role_policy_attachment" "iam_role_policy_attach_autoscaling" {
  depends_on = [
    module.eks
  ]

  for_each   = module.eks.eks_managed_node_groups
  role       = each.value.iam_role_name
  policy_arn = resource.aws_iam_policy.iam_policy_autoscaling.arn
}

# cluster autoscaling helm 설정
resource "helm_release" "eks-autoscaling" {
  depends_on = [
    module.eks
  ]

  create_namespace = true
  namespace        = "kube-system"
  name             = "eks-autoscaling"
  repository       = "https://kubernetes.github.io/autoscaler"
  chart            = "cluster-autoscaler"
  version          = "9.21.0"

  dynamic "set" {
    for_each = {
      "autoDiscovery.clusterName" = local.eks_cluster_name
      "autoDiscovery.enabled"     = "true"
      "cloudProvider"             = "aws"
      "awsRegion"                 = local.region.name
      "sslCertPath"               = "/etc/kubernetes/pki/ca.crt"
      "rbac.create"               = "true",

      # scale down enable
      "extraArgs.scale-down-enabled" = "true",
      # 불필요한 노드를 스케일 다운하기 전까지 경과 시간
      "extraArgs.scale-down-unneeded-time" = "2m",
      # 스케일 업 후 스케일 다운 평가가 다시 시작되기 전까지 경과 시간(유휴시간)
      "extraArgs.scale-down-delay-after-add" = "2m"
    }
    content {
      name  = set.key
      value = set.value
    }
  }
}
