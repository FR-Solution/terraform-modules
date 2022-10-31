#### LB ######
##-->
resource "yandex_lb_target_group" "master-tg" {
  name        = "${var.k8s_global_vars.cluster_name}${yandex_vpc_network.cluster-vpc.id}"
  region_id   = "ru-central1"

  dynamic "target" {
    for_each = "${var.k8s_global_vars.ssl_for_each_map.master_instance_list_map}"
    content {
      subnet_id = "${yandex_vpc_subnet.master-subnets[try(var.master_zones[target.key], var.default_master_zone)].id}"
      address   = "${yandex_compute_instance.master[target.key].network_interface.0.ip_address}"
    }
  }
}

resource "yandex_lb_network_load_balancer" "api-internal" {
  name = "lb-api-${var.k8s_global_vars.cluster_name}"
  type = "external"
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
