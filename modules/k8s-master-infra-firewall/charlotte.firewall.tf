module "firewall" {
    depends_on = [
      sgroups_group.masters
    ]
    source = "../charlotte"
    security_groups = local.charlotte_payload
}

resource "sgroups_network" "masters" {

    for_each = var.cluster_instances

    name    = substr(sha256("${each.value}/32"), 0, 10)
    cidr    = "${each.value}/32"
}

resource "sgroups_group" "masters" {
    depends_on = [
      sgroups_network.masters
    ]
    name        = "kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name}/masters"
    networks    = join(",", flatten([
        for network in sgroups_network.masters:
            network.name
    ]))
}
