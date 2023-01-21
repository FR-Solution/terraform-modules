# resource "yandex_vpc_subnet" "master-subnets" {
#     for_each = local.current_subnet
    
#     v4_cidr_blocks  = [each.key]
#     zone            = each.value
#     network_id      = data.yandex_vpc_network.cluster-vpc.id
#     name            = "vpc-${var.k8s_global_vars.cluster_metadata.cluster_name}-${var.master_group.name}-${each.value}" 
#     route_table_id  = data.yandex_vpc_route_table.cluster-vpc-route-table.id
# }
