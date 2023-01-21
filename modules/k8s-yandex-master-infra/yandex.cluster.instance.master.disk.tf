resource "yandex_compute_disk" "etcd" {
  for_each  = local.instances_disk_map

  name  = "${split("_", each.key)[0]}-${split("_", each.key)[1]}-${var.k8s_global_vars.cluster_metadata.cluster_name}"
  labels = {}
  size = var.master_group.resources.disk.secondary_disk["${split("_", each.key)[0]}"].size
  type = var.master_group.resources.disk.secondary_disk["${split("_", each.key)[0]}"].type
  zone = var.master_group.resources_overwrite["${split("-", split("_", each.key)[1])[0]}-${split("-", split("_", each.key)[1])[2]}"].network_interface.zone

}
