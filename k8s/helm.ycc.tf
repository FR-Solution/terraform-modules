resource "yandex_iam_service_account" "cloud-controller" {
  name        = "cloud-controller-${var.cluster_name}"
  description = "service account to manage VMs in cluster and cloud ${var.cluster_name}" 
}

resource "yandex_iam_service_account_key" "cloud-controller-key" {
  service_account_id = yandex_iam_service_account.cloud-controller.id
  description        = "key for service account"
  key_algorithm      = "RSA_4096"
  

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
  }
}


resource "helm_release" "ycc" {

  name       = "ycc"
  chart      = "templates/helm/yandex-cloud-controller"
  namespace  = "fraima-cloud-controllers"
  create_namespace  = true
  values = [
    templatefile("templates/helm/yandex-cloud-controller/values.yaml", {
        yandex_cloud_controller_sa = local.yandex-cloud-controller-sa
        cluster_name = var.cluster_name
    })
  ]
}
