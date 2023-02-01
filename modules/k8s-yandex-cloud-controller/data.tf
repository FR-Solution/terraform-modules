
data "yandex_iam_service_account" "yandex-k8s-controllers" {
  name = var.yandex_cloud_controller_sa_name
}

data "yandex_vpc_network" "cluster-vpc" {
  name = var.yandex_default_vpc_name
}

data "yandex_vpc_route_table" "cluster-vpc-route-table" {
  name = var.yandex_default_route_table_name
}
