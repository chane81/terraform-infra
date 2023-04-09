# persistent volume 에 사용할 storage class 정의
resource "kubernetes_storage_class" "sc_gp3" {
  depends_on = [
    module.eks
  ]

  metadata {
    name = "gp3"
  }

  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Delete"
  parameters = {
    type                        = "gp3"
    "csi.storage.k8s.io/fstype" = "ext4"
  }
  volume_binding_mode = "WaitForFirstConsumer"
}
