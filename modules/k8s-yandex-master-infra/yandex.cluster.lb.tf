#### LB ######
##-->
resource "yandex_lb_target_group" "master-tg" {
  name        = "${var.k8s_global_vars.cluster_name}${var.master_group.vpc_id}"
  region_id   = "ru-central1"

  dynamic "target" {
    for_each = "${local.master_instance_list_map}"
    content {
      subnet_id = try(var.master_group.subnet_id_overwrite[target.key].subnet, var.master_group.default_subnet_id)
      address   = "${yandex_compute_instance.master[target.key].network_interface.0.ip_address}"
    }
  }
}

resource "yandex_lb_network_load_balancer" "api-external" {
  name = "lb-api-${var.k8s_global_vars.cluster_name}"
  type = "external"
  region_id  = "ru-central1"
  listener {
    name = "api-listener-${var.k8s_global_vars.cluster_name}"
    port = var.k8s_global_vars.kubernetes-ports.kube-apiserver-port-lb
    target_port = var.k8s_global_vars.kubernetes-ports.kube-apiserver-port
    
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = "${yandex_lb_target_group.master-tg.id}"

    healthcheck {
      name = "tcp"
      tcp_options {
        port = var.k8s_global_vars.kubernetes-ports.kube-apiserver-port

      }
    }
  }
}
