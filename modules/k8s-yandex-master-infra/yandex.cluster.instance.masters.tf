#### MASTERS ######
##-->

resource "yandex_compute_instance" "master" {

  for_each    = local.master_instance_list_map

  name        = "${each.key}-${var.k8s_global_vars.cluster_name}"

  hostname    = format("%s.%s.%s", each.key ,var.k8s_global_vars.cluster_name, var.k8s_global_vars.base_domain)
  platform_id = "standard-v1"

  zone        = try(var.master_group.subnet_id_overwrite[each.key].zone, var.master_group.default_zone)

  labels      = {
    "node-role.kubernetes.io/master" = ""
  }
  resources {
    cores         = var.master_group.resources.core
    memory        = var.master_group.resources.memory
    core_fraction = var.master_group.resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.master_group.os_image
      size = var.master_group.resources.first_disk
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
    subnet_id = try(var.master_group.subnet_id_overwrite[each.key].subnet, var.master_group.default_subnet_id)
    nat = true
  }

  lifecycle {
    ignore_changes = [
      metadata
    ]
  }

 metadata = {
   ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
   user-data = module.k8s-cloud-init-master.cloud-init-render[each.key]
 }

}
