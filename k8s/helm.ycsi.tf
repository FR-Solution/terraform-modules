locals {
  yandex-csi-driver-sa = {
    service_account_id  = yandex_iam_service_account.yandex-csi-controller.id
    created_at          = yandex_iam_service_account.yandex-csi-controller.created_at
    folder_id           = yandex_iam_service_account.yandex-csi-controller.folder_id
    id                  = yandex_iam_service_account_key.yandex-csi-controller-key.id
    key_algorithm       = yandex_iam_service_account_key.yandex-csi-controller-key.key_algorithm
    public_key          = yandex_iam_service_account_key.yandex-csi-controller-key.public_key
    private_key         = yandex_iam_service_account_key.yandex-csi-controller-key.private_key
    vpc_id              = yandex_vpc_network.cluster-vpc.id
  }
}

resource "helm_release" "ycsi" {
  depends_on = [
    helm_release.ycc,
    yandex_resourcemanager_folder_iam_policy.k8s-policy
  ]
  name       = "ycsi"
  chart      = "templates/helm/yandex-csi-driver"
  namespace  = "fraima-csi"
  create_namespace  = true
  values = [
    templatefile("templates/helm/yandex-csi-driver/values.yaml", {
        yandex_csi_driver_sa_sa = local.yandex-csi-driver-sa
        cluster_name = var.cluster_name
    })
  ]
  timeout   = 6000
  wait      = true
  atomic    = true
}
