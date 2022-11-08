data "yandex_resourcemanager_cloud" "current" {
  name = var.yandex_cloud_name
}

data "yandex_resourcemanager_folder" "current" {
  name     = var.yandex_folder_name
  cloud_id = data.yandex_resourcemanager_cloud.current.id
}

resource "yandex_iam_service_account" "cloud-controller-csi" {
  name        = "cloud-controller-csi-${var.cluster_name}"
  description = "service account to manage VMs in cluster and cloud ${var.cluster_name}" 
}

resource "yandex_iam_service_account_key" "cloud-controller-csi-key" {
  service_account_id = yandex_iam_service_account.cloud-controller.id
  description        = "key for service account"
  key_algorithm      = "RSA_4096"

}

resource "yandex_resourcemanager_folder_iam_binding" "admin-account-iam-csi" {
  folder_id   = data.yandex_resourcemanager_folder.current.id
  role        = "admin"
  members     = [
    "serviceAccount:${yandex_iam_service_account.cloud-controller-csi.id}",
  ]
}

locals {
  yandex-csi-driver-sa = {
    service_account_id  = yandex_iam_service_account.cloud-controller.id
    created_at          = yandex_iam_service_account.cloud-controller.created_at
    folder_id           = yandex_iam_service_account.cloud-controller.folder_id
    id                  = yandex_iam_service_account_key.cloud-controller-csi-key.id
    key_algorithm       = yandex_iam_service_account_key.cloud-controller-csi-key.key_algorithm
    public_key          = yandex_iam_service_account_key.cloud-controller-csi-key.public_key
    private_key         = yandex_iam_service_account_key.cloud-controller-csi-key.private_key
    vpc_id              = module.k8s-control-plane.vpc-id
  }
}

resource "helm_release" "ycsi" {
  depends_on = [helm_release.coredns]
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
  timeout = 6000
}
