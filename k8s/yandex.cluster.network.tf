
#### VPC ######
##-->
resource "yandex_vpc_network" "cluster-vpc" {
  name = "vpc.${var.cluster_name}"
}

#### SUBNETS ######
##-->
resource "yandex_vpc_subnet" "master-subnets" {
  v4_cidr_blocks  = [var.master_availability_zones[var.master-configs.zone]]
  zone            = var.master-configs.zone
  network_id      = yandex_vpc_network.cluster-vpc.id
  name            = "vpc-${var.cluster_name}-masters-${var.master-configs.zone}" 
}

resource "yandex_vpc_subnet" "worker-subnets" {
  v4_cidr_blocks  = [var.worker_availability_zones[var.worker-configs.zone]]
  zone            = var.worker-configs.zone
  network_id      = yandex_vpc_network.cluster-vpc.id
  name            = "vpc-${var.cluster_name}-workers-${var.worker-configs.zone}" 
}