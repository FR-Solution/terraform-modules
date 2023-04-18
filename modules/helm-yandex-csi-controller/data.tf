
data "yandex_iam_service_account" "yandex-k8s-controllers" {
  name = try(var.extra_values.module_values.yandex_cloud_controller_sa_name ,var.yandex_cloud_controller_sa_name)
}
