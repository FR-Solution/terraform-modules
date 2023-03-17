resource "sgroups_networks" "networks" {

    dynamic "items" {
      for_each = local.networks_map
      content {
        name    = items.key
        cidr    = items.value
      }
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
    sgroups_groups.groups,
  ]

  for_each = local.rules_access_map

  dynamic "items" {
    for_each = { 
      for access in each.value.access: 

        substr(sha256("${join(",", try(access.ports_from, []))}:${join(",",try(access.ports_to, []))}:${access.protocol}"), 0, 10) => {
          "sg_from"   : each.value.sg_from
          "sg_to"     : each.value.sg_to
          "access"    : {
              "ports_from": try(join(" ", access.ports_from), null)
              "ports_to"  : try(join(" ", access.ports_to),   null)
              "proto"     : access.protocol
        }
      } 
    }
    content {
      proto       = items.value.access.proto
      sg_from     = each.value.sg_from
      sg_to       = each.value.sg_to
      ports_from  = items.value.access.ports_from
      ports_to    = items.value.access.ports_to
    }
  }
}
