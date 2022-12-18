# ### LB ######
# #-->
# data "yandex_lb_target_group" "master-tg" {
#   depends_on = [
#     yandex_compute_instance_group.group1
#   ]
#   name = "${var.k8s_global_vars.cluster_name}${var.master_group.vpc_id}"
# }

# resource "yandex_lb_network_load_balancer" "api-external" {
#   depends_on = [
#     yandex_compute_instance_group.group1
#   ]
#   name = "lb-api-${var.k8s_global_vars.cluster_name}"
#   type = "external"
#   region_id  = "ru-central1"
#   listener {
#     name = "api-listener-${var.k8s_global_vars.cluster_name}"
#     port = var.k8s_global_vars.kubernetes-ports.kube-apiserver-port-lb
#     target_port = var.k8s_global_vars.kubernetes-ports.kube-apiserver-port
    
#     external_address_spec {
#       ip_version = "ipv4"
#     }
#   }
#   attached_target_group {
#     target_group_id = "${data.yandex_lb_target_group.master-tg.id}"

#     healthcheck {
#       name = "tcp"
#       tcp_options {
#         port = var.k8s_global_vars.kubernetes-ports.kube-apiserver-port

#       }
#     }
#   }
# }
