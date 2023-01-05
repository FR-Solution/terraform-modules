data "yandex_resourcemanager_cloud" "current" {
  name = var.yandex_cloud_name
}

data "yandex_resourcemanager_folder" "current" {
  name     = var.yandex_folder_name
  cloud_id = data.yandex_resourcemanager_cloud.current.id
}


#### VPC ######
##-->
resource "yandex_vpc_network" "cluster-vpc" {
  name = "vpc.clusters"
}

resource "yandex_vpc_gateway" "cluster-vpc-gateway" {
  name = "gw-${var.cluster_name}"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "cluster-vpc-route-table" {
  name = "vpc-clusters-route-table"
  network_id = "${yandex_vpc_network.cluster-vpc.id}"
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

resource "yandex_vpc_subnet" "master-subnets" {
    for_each = var.master_availability_zones
    
    v4_cidr_blocks  = [var.master_availability_zones[each.key]]
    zone            = each.key
    network_id      = yandex_vpc_network.cluster-vpc.id
    name            = "vpc-${var.cluster_name}-masters-${each.key}" 
    route_table_id = yandex_vpc_route_table.cluster-vpc-route-table.id
}
