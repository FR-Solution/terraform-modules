resource "yandex_vpc_subnet" "master-subnets" {
    for_each = local.current_overide_set_map
    
    v4_cidr_blocks  = [each.key]
    zone            = each.value
    network_id      = data.yandex_vpc_network.cluster-vpc.id
    name            = "vpc-${var.k8s_global_vars.cluster_metadata.cluster_name}-${var.master_group.name}-${substr(sha256(each.key), 0, 8)}" 
    route_table_id  = data.yandex_vpc_route_table.cluster-vpc-route-table.id
}
