#### MASTERS ######
##-->

resource "yandex_compute_instance" "master" {
  depends_on = [
    yandex_lockbox_secret_version.master_key_keeper_approles_secret_id_all,
    yandex_lockbox_secret_version.master_key_keeper_approles_role_id_all,
  ]
  for_each    = var.k8s_global_vars.master_vars.master_instance_list_map

  name        = "${replace(each.key, "-", "-${local.extra_cluster_name}-")}"
  hostname    = "${replace(each.key, "-", "-${local.extra_cluster_name}-")}.${local.base_cluster_fqdn}"
  
  description = local.cluster_name
  
  platform_id = "standard-v1"

  zone = try(
    local.master_group.resources_overwrite[each.key].network_interface.zone, 
    local.master_group.default_zone 
  )
  
  service_account_id  = data.yandex_iam_service_account.yandex-k8s-controllers.id

  resources {
    cores         = local.master_group.resources.core
    memory        = local.master_group.resources.memory
    core_fraction = local.master_group.resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = try(
        local.master_group.resources_overwrite[each.key].disk.boot.image_id, 
        local.master_group.resources.disk.boot.image_id
      )
      size     = local.master_group.resources.disk.boot.size
      type     = local.master_group.resources.disk.boot.type
    }
  }

  dynamic "secondary_disk" {
    for_each = { 
      for k, v in local.instances_disk_map: 
        k => v 
      if split("_", k )[1] ==  each.key
    }
    content {
      disk_id     = yandex_compute_disk.etcd[secondary_disk.key].id
      auto_delete = local.master_secondary_disk[split("_", secondary_disk.key)[0]].auto_delete
      mode        = local.master_secondary_disk[split("_", secondary_disk.key)[0]].mode
      device_name = join("-", [split("_", secondary_disk.key)[0], "data"])
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.master-subnets[
      "${try(
        local.master_group.resources_overwrite[each.key].network_interface.subnet, 
        local.master_group.default_subnet 
      )}:${try(
        local.master_group.resources_overwrite[each.key].network_interface.zone, 
        local.master_group.default_zone 
      )}"
    ].id
    nat = local.master_group.resources.network_interface.nat
  }

  lifecycle {
    ignore_changes = [
      metadata
    ]
  }

 metadata = {
   user-data = local.user_data[replace(each.key, "-", "-${local.extra_cluster_name}-")]
 }
}