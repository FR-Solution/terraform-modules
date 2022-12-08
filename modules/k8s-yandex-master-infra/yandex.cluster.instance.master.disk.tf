resource "yandex_compute_disk" "etcd" {
  for_each  = local.master_instance_list_map
  

  name  = "etcd-${each.key}-${var.k8s_global_vars.cluster_name}"

  size = var.master_group.resources.etcd_disk
  type = "network-ssd"
  zone = try(var.master_group.subnet_id_overwrite[each.key].zone, var.master_group.default_zone)

}
