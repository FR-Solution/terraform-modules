
data "yandex_resourcemanager_cloud" "current" {
  name = var.cloud.key.name
}

data "yandex_resourcemanager_folder" "current" {
  name     = var.cloud.key.folder_name
  cloud_id = data.yandex_resourcemanager_cloud.current.id
}
