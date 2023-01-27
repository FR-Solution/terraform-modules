resource "yandex_vpc_subnet" "master-subnets" {
    for_each = local.master_instance_list_map
    
    v4_cidr_blocks  = [
      try(
        var.master_group.resources_overwrite[each.key].network_interface.subnet,
        var.master_group.default_subnet
      )
    ]
    zone  = try(
      var.master_group.resources_overwrite[each.key].network_interface.zone,
      var.master_group.default_zone 
    )

    network_id      = data.yandex_vpc_network.cluster-vpc.id
    name            = "${local.master_subnet_prefix_name}-${substr(sha256(each.key), 0, 8)}" 
    route_table_id  = data.yandex_vpc_route_table.cluster-vpc-route-table.id
}
