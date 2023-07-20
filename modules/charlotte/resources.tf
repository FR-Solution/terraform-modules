
# resource "sgroups_network" "networks" {
#   for_each = local.networks_map

#   name    = each.key
#   cidr    = each.value

# }

resource "sgroups_networks" "networks" {

  dynamic "items" {
    for_each = local.networks_map

    content {
      name    = items.key
      cidr    = items.value
    }
  }

}

resource "sgroups_group" "groups" {
    depends_on = [
      sgroups_network.networks
    ]

    for_each    = local.security_groups_network__name__map

    name        = each.key
    networks    = each.value
}

resource "sgroups_rules" "rules" {
  depends_on = [
    sgroups_group.groups,
  ]

  for_each = local.rules_map

  dynamic "items" {
    for_each = { 
      for k, v in each.value.access: 
        k => v
    }
    content {
      proto   = items.key
      sg_from = each.value.sg_from
      sg_to   = each.value.sg_to

      dynamic "ports" {
        for_each = { 
          for access_item in items.value: 
            "${each.value.sg_from}:${each.value.sg_to}:${substr(sha256(try(join(",", access_item.ports_from), "")), 0, 10)}" => access_item
        }
        content {
          s = try(join(",", ports.value.ports_from), null)
          d = try(join(",", ports.value.ports_to),   null)
        }

      }

    }
  }
}
