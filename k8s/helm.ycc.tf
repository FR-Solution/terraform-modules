resource "yandex_iam_service_account" "cloud-controller" {
  name        = "cloud-controller-${var.cluster_name}"
  description = "service account to manage VMs in cluster and cloud ${var.cluster_name}" 
}

resource "yandex_iam_service_account_key" "cloud-controller-key" {
  service_account_id = yandex_iam_service_account.cloud-controller.id
  description        = "key for service account"
  key_algorithm      = "RSA_4096"

}



resource "yandex_resourcemanager_folder_iam_binding" "admin-account-iam" {
  folder_id   = data.yandex_resourcemanager_folder.current.id
  role        = "admin"
  members     = [
    "serviceAccount:${yandex_iam_service_account.cloud-controller.id}",
  ]
}

locals {
  yandex-cloud-controller-sa = {
    service_account_id  = yandex_iam_service_account.cloud-controller.id
    created_at          = yandex_iam_service_account.cloud-controller.created_at
    folder_id           = yandex_iam_service_account.cloud-controller.folder_id
    id                  = yandex_iam_service_account_key.cloud-controller-key.id
    key_algorithm       = yandex_iam_service_account_key.cloud-controller-key.key_algorithm
    public_key          = yandex_iam_service_account_key.cloud-controller-key.public_key
    private_key         = yandex_iam_service_account_key.cloud-controller-key.private_key
    vpc_id              = yandex_vpc_network.cluster-vpc.id
  }
}

resource "helm_release" "ycc" {
  depends_on = [helm_release.coredns]
  name       = "ycc"
  chart      = "templates/helm/yandex-cloud-controller"
  namespace  = "fraima-ccm"
  create_namespace  = true
  values = [
    templatefile("templates/helm/yandex-cloud-controller/values.yaml", {
        yandex_cloud_controller_sa = local.yandex-cloud-controller-sa
        cluster_name = var.cluster_name
    })
  ]
  timeout = 6000
}
