data "yandex_resourcemanager_cloud" "current" {
  name = var.cloud.extra-aargs.name
}

data "yandex_resourcemanager_folder" "current" {
  name     = var.cloud.extra-aargs.folder_name
  cloud_id = data.yandex_resourcemanager_cloud.current.id
}
