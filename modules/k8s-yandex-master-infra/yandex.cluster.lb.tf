#### LB ######
##-->
resource "yandex_lb_target_group" "master-tg" {
  name        = "${var.k8s_global_vars.cluster_metadata.cluster_name}${data.yandex_vpc_network.cluster-vpc.id}"
  region_id   = "ru-central1"


  dynamic "target" {

    for_each = local.current_overide_map
    content {
      subnet_id = yandex_vpc_subnet.master-subnets[target.value.subnet].id
      address   = "${yandex_compute_instance.master["${split("-", target.key)[0]}-${var.k8s_global_vars.k8s-addresses.extra_cluster_name}-${split("-", target.key)[1]}"].network_interface.0.ip_address}"
    }
  }
}

resource "yandex_lb_network_load_balancer" "api-external" {
  name = "lb-api-${var.k8s_global_vars.cluster_metadata.cluster_name}"
  type = "external"
  region_id  = "ru-central1"
  listener {
    name = "api-listener-${var.k8s_global_vars.cluster_metadata.cluster_name}"
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
