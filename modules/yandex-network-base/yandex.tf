
resource "yandex_vpc_network" "cluster-vpc" {
  name = var.vpc.key.name
}

resource "yandex_vpc_gateway" "cluster-vpc-gateway" {
  name = var.gateway.key.name
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "cluster-vpc-route-table" {
  name = var.route-table.key.name
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
