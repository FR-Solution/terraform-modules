resource "yandex_vpc_subnet" "master-subnets" {
    for_each        = local.subnets_set_map

    name            = join("-", [local.cluster_name, substr(sha256(split(":", each.key)[0]), 0, 8)])

    v4_cidr_blocks  = [split(":", each.key)[0]]
    zone            =  split(":", each.key)[1]

    network_id      = data.yandex_vpc_network.cluster-vpc.id
    route_table_id  = data.yandex_vpc_route_table.cluster-vpc-route-table.id
}
