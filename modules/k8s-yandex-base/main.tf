resource "yandex_iam_service_account" "yandex-k8s-controllers" {
  name        = var.k8s-service-account.extra-args.name
  description = var.k8s-service-account.extra-args.description
}

resource "yandex_resourcemanager_folder_iam_binding" "yandex-k8s-controllers" {
  folder_id = data.yandex_resourcemanager_folder.current.id
  role      = "admin"

  members = [
    "serviceAccount:${yandex_iam_service_account.yandex-k8s-controllers.id}",
  ]
}