# #### LB ######
# ##-->
# resource "yandex_lb_target_group" "master-tg" {
#   name        = "${var.k8s_global_vars.cluster_metadata.cluster_name}${data.yandex_vpc_network.cluster-vpc.id}"
#   region_id   = "ru-central1"

# try(var.master_group.resources_overwrite.group["${split("-", target.key)[0]}-${split("-", target.key)[2]}"].zone, var.master_group.default_zone)

#   dynamic "target" {
#     for_each = "${local.master_instance_list_map}"
#     content {
#       subnet_id = (var.master_group.subnets[try(var.master_group.resources_overwrite.group["${split("-", target.key)[0]}-${split("-", target.key)[2]}"].zone, var.master_group.default_zone)]).id
#       address   = "${yandex_compute_instance.master[target.key].network_interface.0.ip_address}"
#     }
#   }
# }

# resource "yandex_lb_network_load_balancer" "api-external" {
#   name = "lb-api-${var.k8s_global_vars.cluster_metadata.cluster_name}"
#   type = "external"
#   region_id  = "ru-central1"
#   listener {
#     name = "api-listener-${var.k8s_global_vars.cluster_metadata.cluster_name}"
#     port = var.k8s_global_vars.kubernetes-ports.kube-apiserver-port-lb
#     target_port = var.k8s_global_vars.kubernetes-ports.kube-apiserver-port
    
#     external_address_spec {
#       ip_version = "ipv4"
#     }
#   }
#   attached_target_group {
#     target_group_id = "${yandex_lb_target_group.master-tg.id}"

#     healthcheck {
#       name = "tcp"
#       tcp_options {
#         port = var.k8s_global_vars.kubernetes-ports.kube-apiserver-port

#       }
#     }
#   }
# }
