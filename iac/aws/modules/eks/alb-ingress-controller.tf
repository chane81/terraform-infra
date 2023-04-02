# alb ingress controller role
module "lb_controller_role" {
  depends_on = [
    module.eks
  ]

  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"

  create_role                   = true
  role_name                     = local.lb_controller_iam_role_name
  role_path                     = "/"
  role_description              = "Used by AWS Load Balancer Controller for EKS"
  role_permissions_boundary_arn = ""

  provider_url = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  oidc_fully_qualified_subjects = [
    "system:serviceaccount:kube-system:${local.lb_controller_service_account_name}"
  ]
  oidc_fully_qualified_audiences = [
    "sts.amazonaws.com"
  ]
}

data "http" "iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.6/docs/install/iam_policy.json"
}

# alb ingress controller 생성
resource "aws_iam_role_policy" "controller" {
  depends_on = [
    data.http.iam_policy,
    module.lb_controller_role
  ]

  name_prefix = "AWSLoadBalancerControllerIAMPolicy"
  policy      = data.http.iam_policy.response_body
  role        = module.lb_controller_role.iam_role_name
}

resource "helm_release" "helm_alb_ingress_controller" {
  depends_on = [
    module.lb_controller_role,
  ]

  name       = "aws-load-balancer-controller"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  namespace  = "kube-system"

  # chart version = 1.4.8
  # app version = 2.4.7
  version = "1.4.8"

  dynamic "set" {
    for_each = {
      "clusterName"           = module.eks.cluster_name
      "serviceAccount.create" = "true"
      "serviceAccount.name"   = local.lb_controller_service_account_name
      "region"                = local.region.name
      "vpcId"                 = local.vpc_id

      "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = module.lb_controller_role.iam_role_arn
    }
    content {
      name  = set.key
      value = set.value
    }
  }
}
