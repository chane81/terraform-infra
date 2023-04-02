locals {
  env = {
    dev = {
      cluster_service_ipv4_cidr = "10.15.0.0/16"
      node_groups = {
        apps = {
          name         = "${var.name}-eks-dev"
          min_size     = 2
          max_size     = 5
          desired_size = 2

          # SPOT Price: 0.0403 USD/h
          # ON_DEMAND Price: : 0.152 USD/h
          # 스펙: 2core, 16gb ram
          instance_types = ["r5.large"]

          /** SPOT / ON_DEMAND */
          capacity_type = "SPOT"

          labels = {
            Environment = var.environment,
            Target      = "application-service"
          }

          tags = {
            Name     = "${var.name}-eks-dev"
            ExtraTag = "application"
          }

          # disk_type = "gp3"
          block_device_mappings = {
            xvda = {
              device_name = "/dev/xvda"
              ebs = {
                volume_size = 32
                volume_type = "gp3"
                iops        = 3000
                throughput  = 150
              }
            }
          }

          update_config = {
            max_unavailable_percentage = 50
          }
        }
      }
    }

    staging = {
      cluster_service_ipv4_cidr = "10.25.0.0/16"
      node_groups = {
        apps = {
          name         = "${var.name}-eks-staging"
          min_size     = 2
          max_size     = 5
          desired_size = 2

          # SPOT Price: 0.0403 USD/h
          # ON_DEMAND Price: : 0.152 USD/h
          # 스펙: 2core, 16gb ram
          instance_types = ["r5.large"]

          /** SPOT / ON_DEMAND */
          capacity_type = "SPOT"

          labels = {
            Environment = var.environment,
            Target      = "application-service"
          }

          tags = {
            Name     = "${var.name}-eks-staging"
            ExtraTag = "application"
          }

          # disk_type = "gp3"
          block_device_mappings = {
            xvda = {
              device_name = "/dev/xvda"
              ebs = {
                volume_size = 32
                volume_type = "gp3"
                iops        = 3000
                throughput  = 150
              }
            }
          }

          update_config = {
            max_unavailable_percentage = 50
          }
        }
      }
    }

    prod = {
      cluster_service_ipv4_cidr = "10.35.0.0/16"
      node_groups = {
        apps = {
          name         = "${var.name}-eks-prod"
          min_size     = 2
          max_size     = 5
          desired_size = 2

          # SPOT Price: 0.0403 USD/h
          # ON_DEMAND Price: : 0.152 USD/h
          # 스펙: 2core, 16gb ram
          instance_types = ["r5.large"]

          /** SPOT / ON_DEMAND */
          capacity_type = "ON_DEMAND"

          labels = {
            Environment = var.environment,
            Target      = "application-service"
          }

          tags = {
            Name     = "${var.name}-eks-prod"
            ExtraTag = "application"
          }

          # disk_type = "gp3"
          block_device_mappings = {
            xvda = {
              device_name = "/dev/xvda"
              ebs = {
                volume_size = 32
                volume_type = "gp3"
                iops        = 3000
                throughput  = 150
              }
            }
          }

          update_config = {
            max_unavailable_percentage = 50
          }
        }
      }
    }
  }

  environment = var.environment

  # name
  name              = var.name
  eks_cluster_name  = "${var.name}-eks-${var.postfix}-${var.environment}"
  vpc_cni_irsa_name = "${var.name}-vpc_cni_irsa_name-${var.postfix}-${var.environment}"

  cluster_service_ipv4_cidr = local.env[var.environment].cluster_service_ipv4_cidr
  vpc_id                    = var.vpc_id
  private_subnets           = var.private_subnets
  region                    = data.aws_region.region

  # auto cluster 관련
  policy_autocaling_name   = "policy-cluster-autoscaler-${local.eks_cluster_name}"
  policy_autocaling_prefix = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy"
  policy_autocaling_arn    = "${local.policy_autocaling_prefix}/${local.policy_autocaling_name}"

  # alb 컨트롤러 설정 관련
  lb_controller_iam_role_name        = "${var.name}-role-lb-controller-${var.environment}"
  lb_controller_service_account_name = "${var.name}-account-lb-${var.environment}"

  # subnet ids
  subnet_ids = concat(var.private_subnets, var.public_subnets)

  # istio namespace
  istio_namespace         = "istio-system"
  istio_ingress_namespace = "istio-ingress"
  istio_repository        = "https://istio-release.storage.googleapis.com/charts"
}
