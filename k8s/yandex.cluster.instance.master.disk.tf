resource "yandex_compute_disk" "etcd" {
  for_each    = local.master_instance_list_map

  name  = "etcd-${each.key}-${var.cluster_name}"

  size = var.master_flavor.secondary_disk
  type = "network-ssd"
  zone = "ru-central1-a"

}

# resource "yandex_compute_disk" "etcd" {
#   for_each    = local.master_instance_list_map
#   name = "etcd-${each.key}-${var.cluster_name}"
#   size = 93 // NB size must be divisible by 93  
#   type = "network-ssd-nonreplicated"
#   zone = "ru-central1-a"

#   disk_placement_policy {
#     disk_placement_group_id = yandex_compute_disk_placement_group.this.id
#   }
# }

# resource "yandex_compute_disk_placement_group" "this" {
#   zone = "ru-central1-a"
# }