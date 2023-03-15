resource "sgroups_networks" "networks" {
    for_each = local.networks_map

    items{
        name    = each.key
        cidr    = each.value
    }
}

resource "sgroups_groups" "groups" {
    depends_on = [
        sgroups_networks.networks
    ]

    for_each    = local.security_groups_network__name__map

    items {
        name        = each.key
        networks    = each.value
    }
}

resource "sgroups_rules" "rules" {
  depends_on = [
    sgroups_groups.groups
  ]

  for_each = local.all_rules_access_map

  items {
    proto       = each.value.access.proto
    sg_from     = each.value.sg_from
    sg_to       = each.value.sg_to
    ports_from  = each.value.access.ports_from
    ports_to    = each.value.access.ports_to
  }

}
