
#### VPC ######
##-->
resource "yandex_vpc_network" "cluster-vpc" {
  name = "vpc.${var.k8s_global_vars.cluster_name}"
}

#### SUBNETS ######
##-->
resource "yandex_vpc_subnet" "master-subnets" {
    for_each = var.master_availability_zones
    
    v4_cidr_blocks  = [var.master_availability_zones[each.key]]
    zone            = each.key
    network_id      = yandex_vpc_network.cluster-vpc.id
    name            = "vpc-${var.k8s_global_vars.cluster_name}-masters-${each.key}" 
}

resource "yandex_vpc_subnet" "worker-subnets" {
    for_each = var.worker_availability_zones

    v4_cidr_blocks  = [var.worker_availability_zones[each.key]]
    zone            = each.key
    network_id      = yandex_vpc_network.cluster-vpc.id
    name            = "vpc-${var.k8s_global_vars.cluster_name}-workers-${each.key}" 
}