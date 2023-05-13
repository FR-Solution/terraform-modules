resource "yandex_compute_disk" "etcd" {
  for_each  = local.instances_disk_map

  name  = "${replace(each.key, "_", "-")}-${local.cluster_name}"

  size = local.master_secondary_disk["${split("_", each.key)[0]}"].size
  type = local.master_secondary_disk["${split("_", each.key)[0]}"].type

  zone = try(var.k8s_global_vars.master_vars.resources_overwrite[split("_", each.key)[1]].network_interface.zone, var.k8s_global_vars.master_vars.default_zone)

  labels = {}

}
