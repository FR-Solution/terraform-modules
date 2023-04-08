
data "yandex_iam_service_account" "yandex-k8s-controllers" {
  name = var.yandex_cloud_controller_sa_name
}
