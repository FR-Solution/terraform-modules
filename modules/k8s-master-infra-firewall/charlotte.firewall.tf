module "firewall" {
    depends_on = [
      sgroups_group.masters,
      sgroups_group.api,
    ]
    source = "../charlotte"
    security_groups = local.charlotte_payload
}

resource "sgroups_network" "masters_internal" {

    for_each = var.cluster_instances_internal

    name    = substr(sha256("${each.value}/32"), 0, 10)
    cidr    = "${each.value}/32"
}

resource "sgroups_network" "masters_external" {

    for_each = var.cluster_instances_external

    name    = substr(sha256("${each.value}/32"), 0, 10)
    cidr    = "${each.value}/32"
}

resource "sgroups_group" "masters" {
    depends_on = [
      sgroups_network.masters_external,
      sgroups_network.masters_internal,
    ]
    name        = "kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name}/masters"
    networks    = join(",", local.networks_master)
}

resource "sgroups_network" "api" {

    name    = substr(sha256("${var.cluster_api_ip}/32"), 0, 10)
    cidr    = "${var.cluster_api_ip}/32"
}

resource "sgroups_group" "api" {
    depends_on = [
      sgroups_network.api
    ]
    name        = "kubernetes/${var.k8s_global_vars.cluster_metadata.cluster_name}/api"
    networks    = substr(sha256("${var.cluster_api_ip}/32"), 0, 10)
}
