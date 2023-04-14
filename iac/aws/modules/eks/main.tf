module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.10"

  cluster_name                    = local.eks_cluster_name
  cluster_version                 = "1.25"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  cluster_service_ipv4_cidr       = local.cluster_service_ipv4_cidr

  vpc_id     = local.vpc_id
  subnet_ids = slice(local.private_subnets, 0, 2)

  # addon
  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
      # Specify the VPC CNI addon should be deployed before compute to ensure
      # the addon is configured before data plane compute resources are created
      # See README for further details
      before_compute = true
      most_recent    = true # To ensure access to the latest settings provided
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
    aws-ebs-csi-driver = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node all port"
      protocol                   = "-1"
      from_port                  = 0
      to_port                    = 0
      type                       = "egress"
      source_node_security_group = true
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    # alb-ingress 사용을 위해 필요
    # 아래 에러 대응(ingress.yml 파일 배포시 에러)
    # Error from server (InternalError): error when creating "ingress.yaml": Internal error occurred: failed calling webhook "vingress.elbv2.k8s.aws": Post "https://aws-load-balancer-webhook-service.kube-system.svc:443/validate-networking-v1-ingress?timeout=10s": context deadline exceeded
    # ingress_allow_access_from_control_plane = {
    #   type                          = "ingress"
    #   protocol                      = "tcp"
    #   from_port                     = 9443
    #   to_port                       = 9443
    #   source_cluster_security_group = true
    #   description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
    # }

    # metrics server
    # metrics_server = {
    #   type                          = "ingress"
    #   protocol                      = "tcp"
    #   from_port                     = 4443
    #   to_port                       = 4443
    #   source_cluster_security_group = true
    #   description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
    # }

    lens_metrics = {
      description                   = "Lens metrics prometheus port"
      protocol                      = "tcp"
      from_port                     = 9090
      to_port                       = 9090
      type                          = "ingress"
      source_cluster_security_group = true
    }

    istio_webhook = {
      description                   = "istio webhook"
      protocol                      = "tcp"
      from_port                     = 15017
      to_port                       = 15017
      type                          = "ingress"
      source_cluster_security_group = true
    }

    # node간 통신 네트워크통신에 대한 설정
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }


    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  tags = merge(
    {
      Name        = local.eks_cluster_name
      Environment = local.environment
    },
    var.common_tag
  )

  # node group 설정 ===========================
  # default 설정
  eks_managed_node_group_defaults = {
    disk_size      = 32
    instance_types = ["t3.large"]
    iam_role_additional_policies = {
      AmazonS3FullAccess                   = "arn:aws:iam::aws:policy/AmazonS3FullAccess",
      AmazonEC2ContainerRegistryFullAccess = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
      AmazonEBSCSIDriverPolicy             = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy",
      AmazonSQSFullAccess                  = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
    }

    # We are using the IRSA created below for permissions
    # However, we have to deploy with the policy attached FIRST (when creating a fresh cluster)
    # and then turn this off after the cluster/node group is created. Without this initial policy,
    # the VPC CNI fails to assign IPs and nodes cannot join the cluster
    # See https://github.com/aws/containers-roadmap/issues/1666 for more context
    iam_role_attach_cni_policy = true
    key_name                   = local.node_key_pair_name
  }

  eks_managed_node_groups = local.env[local.environment].node_groups
  # node group 설정 ===========================


  # aws-auth configmap
  # create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

  # auth roles/users/accounts
  aws_auth_roles    = local.map_roles
  aws_auth_users    = local.map_users
  aws_auth_accounts = local.map_accounts
}

module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name_prefix      = "VPC-CNI-IRSA"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true
  vpc_cni_enable_ipv6   = false

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }

  tags = merge(
    {
      # tags 의 "Name"을 따라 ec2 인스턴스 이름도 동일하게 생성 되므로 참고할 것
      Name        = local.vpc_cni_irsa_name
      Environment = local.environment
    },
    var.common_tag
  )
}


# 각 서브넷 태그에 eks 태그 삽업 (eks auto discovery)
# Amazon EKS는 Kubernetes 버전 1.19부터는 kubernetes.io 태그 없이도 서브넷 자동 검색을 지원함 (
# 낮은버전 eks 설치를 대비해 태그 설정
resource "aws_ec2_tag" "vpc_subnet_tags" {
  count       = length(local.subnet_ids)
  resource_id = element(local.subnet_ids, count.index)

  key   = "kubernetes.io/cluster/${local.eks_cluster_name}"
  value = "shared"
}
