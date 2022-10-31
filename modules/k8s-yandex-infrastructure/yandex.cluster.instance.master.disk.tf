resource "yandex_compute_disk" "etcd" {
  for_each  = var.k8s_global_vars.ssl_for_each_map.master_instance_list_map

  name  = "etcd-${each.key}-${var.k8s_global_vars.cluster_name}"

  size = var.master_flavor.secondary_disk
  type = "network-ssd"
  zone = try(var.master_zones[each.key], var.default_master_zone)

}
