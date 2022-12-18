# # resource "yandex_iam_service_account" "worker-sa" {

# #   name        = "worker-group-test"
# #   description = "service account to manage VMs in cloud ${var.k8s_global_vars.cluster_name}" 
# # }



# resource "yandex_iam_service_account" "ig-sa" {
#   name        = "ig-sa"
#   description = "service account to manage IG"
# }

# resource "yandex_resourcemanager_folder_iam_binding" "editor" {
#   folder_id = "b1g7220ns3r5dts1lha3"
#   role      = "admin"
#   members   = [
#     "serviceAccount:${yandex_iam_service_account.ig-sa.id}",
#   ]
#   depends_on = [
#     yandex_iam_service_account.ig-sa,
#   ]
# }



# resource "yandex_compute_instance_group" "group1" {
#       depends_on = [
#         yandex_iam_service_account.ig-sa,
#         yandex_resourcemanager_folder_iam_binding.editor
#       ]
#   name                = "test-ig"
#   folder_id           = "b1g7220ns3r5dts1lha3"
#   service_account_id  = yandex_iam_service_account.ig-sa.id
  
#   deletion_protection = false

#   instance_template {
#     service_account_id  = yandex_iam_service_account.master-sa["master-5dddc7a4-1"].id
#     hostname = "master-${var.k8s_global_vars.extra_cluster_name}-{instance.index}.${var.k8s_global_vars.cluster_name}.${var.k8s_global_vars.base_domain}"
#     name = "master-${var.k8s_global_vars.extra_cluster_name}-{instance.index}"
#     platform_id = "standard-v1"

#     resources {
#     cores         = var.master_group.resources.core
#     memory        = var.master_group.resources.memory
#     core_fraction = var.master_group.resources.core_fraction
#     }


#     boot_disk {
#       initialize_params {
#         image_id = var.master_group.os_image
#         size = var.master_group.resources.first_disk
#       }
#     }

#     secondary_disk {
#       # disk_id = yandex_compute_disk.etcd[each.key].id
#       # auto_delete = false
#       mode = "READ_WRITE"
#       device_name = "etcd-data"
#       initialize_params {
#         size = 20
#         type = "network-ssd"
#       }
#     }

#     network_interface {
#       network_id = "${var.master_group.vpc_id}"
#       subnet_ids = [var.master_group.default_subnet_id]
#       nat = true

#     }

#     metadata = {
#         user-data = module.k8s-cloud-init-master.cloud-init-render["master-5dddc7a4-1"]
#     }
#     network_settings {
#       type = "STANDARD"
      
#     }
#   }

#   scale_policy {
#     fixed_scale {
#       size = var.master_group.count
#     }
#   }

#   allocation_policy {
#     zones = [var.master_group.default_zone]
#   }
  
#   load_balancer {
#     target_group_name = "${var.k8s_global_vars.cluster_name}${var.master_group.vpc_id}"
#   }

#   deploy_policy {
#     max_unavailable = 1
#     max_creating    = var.master_group.count
#     max_expansion   = 0
#     max_deleting    = 1
#   }
# }

