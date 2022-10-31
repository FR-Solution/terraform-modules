#### MASTERS ######
##-->
resource "yandex_compute_instance" "master" {

  for_each    = local.master_instance_list_map

  name        = "${each.key}-${var.cluster_name}"

  hostname    = format("%s.%s.%s", each.key ,var.cluster_name, var.base_domain)
  platform_id = "standard-v1"
  zone        = var.master-configs.zone
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
    subnet_id = yandex_vpc_subnet.master-subnets.id
    nat = true
  }

  lifecycle {
    ignore_changes = [
      metadata
    ]
  }

 metadata = {
   ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
   user-data = module.k8s-master-cloud-init.cloud-init[each.key]
 }

}

output "cloud_init" {
    value = "${yandex_compute_instance.master[*].master-1.network_interface[*].nat_ip_address}"
}
