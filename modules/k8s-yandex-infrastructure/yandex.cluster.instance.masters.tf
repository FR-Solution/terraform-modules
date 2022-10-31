#### MASTERS ######
##-->
resource "yandex_compute_instance" "master" {

  for_each    = var.k8s_global_vars.ssl_for_each_map.master_instance_list_map

  name        = "${each.key}-${var.k8s_global_vars.cluster_name}"

  hostname    = format("%s.%s.%s", each.key ,var.k8s_global_vars.cluster_name, var.k8s_global_vars.base_domain)
  platform_id = "standard-v1"
  zone        = try(var.master_zones[each.key], var.default_master_zone)
  labels      = {
    "node-role.kubernetes.io/master" = ""
  }
  resources {
    cores         = var.master_flavor.core
    memory        = var.master_flavor.memory
    core_fraction = var.master_flavor.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.base_os_image
      size = 20
    }
  }

  secondary_disk {
    disk_id = yandex_compute_disk.etcd[each.key].id
    auto_delete = false
    mode = "READ_WRITE"
    device_name = "etcd-data"
  }

  service_account_id = yandex_iam_service_account.master-sa[each.key].id

  network_interface {
    subnet_id = yandex_vpc_subnet.master-subnets[try(var.master_zones[each.key], var.default_master_zone)].id
    nat = true
  }

  lifecycle {
    ignore_changes = [
      metadata
    ]
  }

 metadata = {
   ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
   user-data = var.cloud_init_template[each.key]
 }

}

# output "cloud_init" {
#     value = "${yandex_compute_instance.master[*].master-1.network_interface[*].nat_ip_address}"
# }
