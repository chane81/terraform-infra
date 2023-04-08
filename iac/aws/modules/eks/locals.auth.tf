locals {
  # "Additional AWS account numbers to add to the aws-auth configmap."
  map_accounts = [
    "292667926659",
  ]

  # "Additional IAM roles to add to the aws-auth configmap."
  map_roles = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]

  # eks user
  map_users = [
    {
      userarn  = "arn:aws:iam::292667926659:root"
      username = "root"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::292667926659:user/eks-user"
      username = "eks-user"
      groups   = ["system:masters"]
    },

  ]
}
