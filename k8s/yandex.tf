data "yandex_resourcemanager_cloud" "current" {
  name = var.yandex_cloud_name
}

data "yandex_resourcemanager_folder" "current" {
  name     = var.yandex_folder_name
  cloud_id = data.yandex_resourcemanager_cloud.current.id
}

data "yandex_vpc_network" "cluster-vpc" {
  name = "vpc.clusters"
}

data "yandex_vpc_route_table" "cluster-vpc-route-table" {
  name = "vpc-clusters-route-table"
}

data "yandex_iam_service_account" "yandex-k8s-controllers" {
  name = "yandex-k8s-controllers"
}

resource "yandex_iam_service_account_key" "yandex-k8s-controllers-key" {
  service_account_id = data.yandex_iam_service_account.yandex-k8s-controllers.id
  description        = "key for service account"
  key_algorithm      = "RSA_4096"

}

resource "yandex_vpc_subnet" "master-subnets" {
    for_each = var.master_availability_zones
    
    v4_cidr_blocks  = [var.master_availability_zones[each.key]]
    zone            = each.key
    network_id      = data.yandex_vpc_network.cluster-vpc.id
    name            = "vpc-${var.cluster_name}-masters-${each.key}" 
    route_table_id  = data.yandex_vpc_route_table.cluster-vpc-route-table.id
}

locals {
  yandex-k8s-controllers-sa = {
    service_account_id  = data.yandex_iam_service_account.yandex-k8s-controllers.id
    created_at          = data.yandex_iam_service_account.yandex-k8s-controllers.created_at
    folder_id           = data.yandex_iam_service_account.yandex-k8s-controllers.folder_id
    vpc_id              = data.yandex_vpc_network.cluster-vpc.id
    route_table_id      = data.yandex_vpc_route_table.cluster-vpc-route-table.id
    id                  = yandex_iam_service_account_key.yandex-k8s-controllers-key.id
    key_algorithm       = yandex_iam_service_account_key.yandex-k8s-controllers-key.key_algorithm
    public_key          = yandex_iam_service_account_key.yandex-k8s-controllers-key.public_key
    private_key         = yandex_iam_service_account_key.yandex-k8s-controllers-key.private_key

  }
}