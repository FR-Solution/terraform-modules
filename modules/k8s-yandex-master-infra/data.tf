data "yandex_iam_service_account" "yandex-k8s-controllers" {
  name = var.k8s_global_vars.k8s_provider.service_account_name
}

data "yandex_resourcemanager_cloud" "current" {
  name = var.cloud_metadata.cloud_name
}

data "yandex_resourcemanager_folder" "current" {
  name     = var.cloud_metadata.folder_name
  cloud_id = data.yandex_resourcemanager_cloud.current.id
}

data "yandex_vpc_network" "cluster-vpc" {
  name = var.master_group.vpc_name
}

data "yandex_vpc_route_table" "cluster-vpc-route-table" {
  name = var.master_group.route_table_name
}
