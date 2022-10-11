#### LB ######
##-->
resource "yandex_lb_target_group" "master-tg" {
  name        = "${var.master-configs.group}-target-group-${var.cluster_name}"
  region_id   = "ru-central1"

  dynamic "target" {
    for_each = "${local.master_instance_list_map}"
    content {
      subnet_id = "${yandex_vpc_subnet.master-subnets.id}"
      address   = "${yandex_compute_instance.master[target.key].network_interface.0.ip_address}"
    }
  }
}

resource "yandex_lb_network_load_balancer" "api-internal" {
  name = "lb-api-${var.cluster_name}"
  type = "external"
  listener {
    name = "api-listener-${var.cluster_name}"
    port = var.kube-apiserver-port-lb
    target_port = var.kube-apiserver-port
    
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = "${yandex_lb_target_group.master-tg.id}"

    healthcheck {
      name = "tcp"
      tcp_options {
        port = var.kube-apiserver-port

      }
    }
  }
}

output "lb" {
    value = yandex_lb_network_load_balancer.api-internal.listener[*].external_address_spec[*].address
}
