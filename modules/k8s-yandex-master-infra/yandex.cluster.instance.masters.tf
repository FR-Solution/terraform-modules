#### MASTERS ######
##-->
data "yandex_iam_service_account" "yandex-k8s-controllers" {
  name = "yandex-k8s-controllers"
}

resource "yandex_compute_instance" "master" {
  depends_on = [
    yandex_lockbox_secret_version.master_key_keeper_approles_secret_id_all,
    yandex_lockbox_secret_version.master_key_keeper_approles_role_id_all,
  ]
  for_each    = local.master_instance_list_map
  labels = {}
  name        = "${each.key}"
  description = var.k8s_global_vars.cluster_metadata.cluster_name
  hostname    = format("%s.%s.%s", each.key, var.k8s_global_vars.cluster_metadata.cluster_name, var.k8s_global_vars.cluster_metadata.base_domain)
  platform_id = "standard-v1"

  zone                = try(var.master_group.resources_overwrite.group["${split("-", each.key)[0]}-${split("-", each.key)[2]}"].zone, var.master_group.default_zone)
  
  service_account_id  = data.yandex_iam_service_account.yandex-k8s-controllers.id

  # placement_policy {
  #   placement_group_id = 
  # }

  resources {
    cores         = var.master_group.resources.core
    memory        = var.master_group.resources.memory
    core_fraction = var.master_group.resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = try(var.master_group.resources_overwrite.group["${split("-", each.key)[0]}-${split("-", each.key)[2]}"].disk.boot.image_id, var.master_group.resources.disk.boot.image_id)
      size     = var.master_group.resources.disk.boot.size
      type     = var.master_group.resources.disk.boot.type
    }
  }

  dynamic "secondary_disk" {
    for_each = { for k, v in local.instances_disk_map  : k => v if split("_", k )[1] ==  each.key}
    content {
      disk_id     = yandex_compute_disk.etcd[secondary_disk.key].id
      auto_delete = var.master_group.resources.disk.secondary_disk[split("_", secondary_disk.key)[0]].auto_delete
      mode        = var.master_group.resources.disk.secondary_disk[split("_", secondary_disk.key)[0]].mode
      device_name = "${split("_", secondary_disk.key)[0]}-data"
    }
  }

  network_interface {
    subnet_id = (var.master_group.subnets[try(var.master_group.resources_overwrite.group["${split("-", each.key)[0]}-${split("-", each.key)[2]}"].zone, var.master_group.default_zone)]).id
    nat = var.master_group.resources.network_interface.nat
  }

  lifecycle {
    ignore_changes = [
      metadata
    ]
  }

 metadata = {
   user-data = module.k8s-cloud-init-master.cloud-init-render[each.key]
 }

}
