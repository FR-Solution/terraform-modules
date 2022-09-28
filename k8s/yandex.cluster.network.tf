
#### VPC ######
##-->
resource "yandex_vpc_network" "cluster-vpc" {
  name = "vpc.${var.cluster_name}"
}

#### SUBNETS ######
##-->
resource "yandex_vpc_subnet" "cluster-subnet" {
  for_each        = "${var.availability_zones}"
  v4_cidr_blocks  = [each.value]
  zone            = "${each.key}"
  network_id      = "${yandex_vpc_network.cluster-vpc.id}"
  name            = "vpc-${each.key}-${var.cluster_name}" 
}
