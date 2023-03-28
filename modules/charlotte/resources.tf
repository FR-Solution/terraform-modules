
resource "sgroups_network" "networks" {
  for_each = local.networks_map

  name    = each.key
  cidr    = each.value

}
resource "sgroups_group" "groups" {
    depends_on = [
      sgroups_network.networks
    ]

    for_each    = local.security_groups_network__name__map

    name        = each.key
    networks    = each.value
}

resource "sgroups_rule" "rules" {
  depends_on = [
    sgroups_group.groups,
  ]

  for_each = local.rules_access_map

  proto       = each.value.access.proto
  sg_from     = each.value.sg_from
  sg_to       = each.value.sg_to
  ports_from  = each.value.access.ports_from
  ports_to    = each.value.access.ports_to

}

