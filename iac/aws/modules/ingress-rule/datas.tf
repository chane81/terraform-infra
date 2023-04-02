# ingress argocd data
# data "kubernetes_ingress_v1" "argocd_ingress" {
#   depends_on = [
#     resource.kubernetes_manifest.argocd_manifest
#   ]

#   metadata {
#     name      = "argocd-ingress"
#     namespace = "istio-system"
#   }
# }

# route53 zone - main domain
data "aws_route53_zone" "zone_main" {
  name         = local.domain
  private_zone = false
}

# region
data "aws_region" "region" {}

# eks cluster
data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.eks_cluster_name
}

# alb
data "aws_lbs" "alb" {
  depends_on = [
    resource.kubernetes_ingress_v1.apps_ingress
  ]

  tags = {
    # eks 클러스터명
    "elbv2.k8s.aws/cluster" = data.aws_eks_cluster.cluster.name

    # alb group 명
    "ingress.k8s.aws/stack" = "partner"
  }
}
