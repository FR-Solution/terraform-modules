resource "yandex_iam_service_account_key" "yandex-k8s-controllers-key" {
  service_account_id = data.yandex_iam_service_account.yandex-k8s-controllers.id
  description        = "key for cluster <${var.global_vars.cluster_metadata.cluster_name}>"
  key_algorithm      = "RSA_4096"

}

locals {
  yandex_k8s_csi_controller_sa_payload = {
    service_account_id  = data.yandex_iam_service_account.yandex-k8s-controllers.id
    created_at          = data.yandex_iam_service_account.yandex-k8s-controllers.created_at
    folder_id           = data.yandex_iam_service_account.yandex-k8s-controllers.folder_id
    service_account_json = {
      id                  = yandex_iam_service_account_key.yandex-k8s-controllers-key.id
      service_account_id  = yandex_iam_service_account_key.yandex-k8s-controllers-key.service_account_id
      created_at          = yandex_iam_service_account_key.yandex-k8s-controllers-key.created_at
      key_algorithm       = yandex_iam_service_account_key.yandex-k8s-controllers-key.key_algorithm
      public_key          = yandex_iam_service_account_key.yandex-k8s-controllers-key.public_key
      private_key         = yandex_iam_service_account_key.yandex-k8s-controllers-key.private_key
    }

  }
}