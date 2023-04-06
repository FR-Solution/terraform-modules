locals {
  internal = flatten([
        for network in sgroups_network.masters_internal:
            network.name

    ])
  external = flatten([
        for network in sgroups_network.masters_external:
            network.name

    ])

  networks_master = concat(local.internal, local.external)
}
