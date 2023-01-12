variable "yandex_cloud_name" {
  description = "module:K8S "
  type        = string
  default     = "cloud-uid-vf465ie7"
}

variable "yandex_folder_name" {
  description = "module:K8S "
  type        = string
  default     = "example"
}

data "yandex_resourcemanager_folder" "current" {
  name     = var.yandex_folder_name
  cloud_id = data.yandex_resourcemanager_cloud.current.id
}

data "yandex_resourcemanager_cloud" "current" {
  name = var.yandex_cloud_name
}


#### VPC ######
##-->
resource "yandex_vpc_network" "cluster-vpc" {
  name = "vpc.clusters"
}

resource "yandex_vpc_gateway" "cluster-vpc-gateway" {
  name = "gw-clusters"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "cluster-vpc-route-table" {
  name = "vpc-clusters-route-table"
  network_id = yandex_vpc_network.cluster-vpc.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.cluster-vpc-gateway.id
  }
  lifecycle {
    ignore_changes = [
      static_route
    ]
  }
}

resource "yandex_iam_service_account" "yandex-k8s-controllers" {
  name        = "yandex-k8s-controllers"
  description = "service account to manage VMs in cluster and cloud clusters" 
}

resource "yandex_resourcemanager_folder_iam_binding" "yandex-k8s-controllers" {
  folder_id = data.yandex_resourcemanager_folder.current.id
  role      = "admin"

  members = [
    "serviceAccount:${yandex_iam_service_account.yandex-k8s-controllers.id}",
  ]
}