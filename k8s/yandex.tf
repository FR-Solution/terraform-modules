data "yandex_resourcemanager_cloud" "current" {
  name = var.cloud_metadata.cloud_name
}

data "yandex_resourcemanager_folder" "current" {
  name     = var.cloud_metadata.folder_name
  cloud_id = data.yandex_resourcemanager_cloud.current.id
}

data "yandex_vpc_network" "cluster-vpc" {
  name = local.master_group_merge.vpc_name
}

data "yandex_vpc_route_table" "cluster-vpc-route-table" {
  name = local.master_group_merge.route_table_name
}

data "yandex_iam_service_account" "yandex-k8s-controllers" {
  name = var.yandex_cloud_controller_sa_name
}

resource "yandex_iam_service_account_key" "yandex-k8s-controllers-key" {
  service_account_id = data.yandex_iam_service_account.yandex-k8s-controllers.id
  description        = "key for service account"
  key_algorithm      = "RSA_4096"

}

locals {
  yandex-k8s-controllers-sa = {
    service_account_id  = data.yandex_iam_service_account.yandex-k8s-controllers.id
    created_at          = data.yandex_iam_service_account.yandex-k8s-controllers.created_at
    folder_id           = data.yandex_iam_service_account.yandex-k8s-controllers.folder_id
    vpc_id              = data.yandex_vpc_network.cluster-vpc.id
    route_table_id      = data.yandex_vpc_route_table.cluster-vpc-route-table.id
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