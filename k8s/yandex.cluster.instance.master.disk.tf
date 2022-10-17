resource "yandex_compute_disk" "etcd" {
  for_each    = local.master_instance_list_map

  name  = "etcd-${each.key}-${var.cluster_name}"

  size = 20
  type = "network-ssd"
  zone = "ru-central1-a"

}
