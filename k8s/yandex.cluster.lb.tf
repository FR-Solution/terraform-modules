#### LB ######
##-->
resource "yandex_lb_target_group" "master-tg" {
  name        = "${var.master-configs.group}-target-group-${var.cluster_name}"
  region_id   = "ru-central1"

  dynamic "target" {
    for_each = "${var.availability_zones}"
    content {
      subnet_id = "${yandex_vpc_subnet.cluster-subnet[target.key].id}"
      address   = "${yandex_compute_instance.master[target.key].network_interface.0.ip_address}"
    }
  }
}


resource "yandex_lb_network_load_balancer" "master-lb-etcd" {
  name = "lb-etcd-${var.cluster_name}"

  listener {
    name = "etcd-server-${var.cluster_name}"
    port = 2379
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = "${yandex_lb_target_group.master-tg.id}"

    healthcheck {
      name = "etcd-server"
      tcp_options {
        port = 2379

      }

    }
  }
}
resource "yandex_lb_network_load_balancer" "master-lb" {
  depends_on = [
    yandex_lb_network_load_balancer.master-lb-etcd
  ]
  name = "lb-api-${var.cluster_name}"
  listener {
    name = "api-listener-${var.cluster_name}"
    port = 6443
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = "${yandex_lb_target_group.master-tg.id}"

    healthcheck {
      name = "tcp"
      tcp_options {
        port = 6443

      }
    }
  }
}