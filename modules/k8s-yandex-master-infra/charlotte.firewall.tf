module "firewall" {
    depends_on = [
      sgroups_group.masters
    ]
    source = "../charlotte"
    security_groups = local.charlotte_payload
}

resource "sgroups_network" "masters" {

    for_each = yandex_compute_instance.master

    name    = substr(sha256("${each.value.network_interface[0].ip_address}/32"), 0, 10)
    cidr    = "${each.value.network_interface[0].ip_address}/32"
}

resource "sgroups_group" "masters" {
    depends_on = [
      sgroups_network.masters
    ]
    name        = "kubernetes/${local.cluster_name}/masters"
    networks    = join(",", flatten([
        for network in sgroups_network.masters:
            network.name
    ]))
}
