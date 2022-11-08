
#### SUBNETS ######
##-->

resource "yandex_vpc_subnet" "worker-subnets" {
    for_each = var.worker_availability_zones

    v4_cidr_blocks  = [each.value]
    zone            = each.key
    network_id      = var.vpc-id
    name            = "vpc-${var.k8s_global_vars.cluster_name}-workers-${each.key}" 
}