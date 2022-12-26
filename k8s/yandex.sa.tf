resource "yandex_iam_service_account" "yandex-cloud-controller" {
  name        = "yandex-cloud-controller-${var.cluster_name}"
  description = "service account to manage VMs in cluster and cloud ${var.cluster_name}" 
}

resource "yandex_iam_service_account_key" "yandex-cloud-controller-key" {
  service_account_id = yandex_iam_service_account.yandex-cloud-controller.id
  description        = "key for service account"
  key_algorithm      = "RSA_4096"

}

resource "yandex_iam_service_account" "yandex-machine-controller" {
  name        = "yandex-machine-controller-${var.cluster_name}"
  description = "service account to manage VMs in cluster and cloud ${var.cluster_name}" 
}

resource "yandex_iam_service_account_key" "yandex-machine-controller-key" {
  service_account_id = yandex_iam_service_account.yandex-machine-controller.id
  description        = "key for service account"
  key_algorithm      = "RSA_4096"
}

resource "yandex_iam_service_account" "yandex-csi-controller" {
  name        = "yandex-csi-controller-${var.cluster_name}"
  description = "service account to manage VMs in cluster and cloud ${var.cluster_name}" 
}

resource "yandex_iam_service_account_key" "yandex-csi-controller-key" {
  service_account_id = yandex_iam_service_account.yandex-csi-controller.id
  description        = "key for service account"
  key_algorithm      = "RSA_4096"

}
