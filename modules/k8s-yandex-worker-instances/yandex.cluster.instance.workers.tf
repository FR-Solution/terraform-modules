# resource "yandex_iam_service_account" "worker-sa" {
#   for_each    = local.worker_instance_list_map

#   name        = "${each.key}-${var.k8s_global_vars.cluster_name}"
#   description = "service account to manage VMs in cloud ${var.k8s_global_vars.cluster_name}" 
# }

# resource "yandex_compute_instance" "worker" {

#     for_each    = local.worker_instance_list_map
    
#     name        = "${each.key}-${var.k8s_global_vars.cluster_name}"
#     hostname    = format("%s.%s.%s", each.key ,var.k8s_global_vars.cluster_name, var.k8s_global_vars.base_domain)
#     platform_id = "standard-v1"
#     zone        = var.zone
#     labels      = {
#         "node-role.kubernetes.io/worker" = ""
#     }
#     resources {
#         cores         = var.worker_flavor.core
#         memory        = var.worker_flavor.memory
#         core_fraction = var.worker_flavor.core_fraction
#     }

#     boot_disk {
#         initialize_params {
#         image_id = var.base_worker_os_image
#         size = 20
#         }
#     }

#     service_account_id = yandex_iam_service_account.worker-sa[each.key].id

#     network_interface {
#         subnet_id = var.default_subnet_id
#         nat = true
#     }

#     lifecycle {
#         ignore_changes = [
#         metadata
#         ]
#     }

#     metadata = {
#         ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
#         user-data = module.k8s-cloud-init-worker.cloud-init-render[each.key]
#     }
# }
