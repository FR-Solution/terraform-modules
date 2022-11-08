
#### WORKERS ######
##-->

resource "yandex_compute_instance" "worker" {

    for_each    = var.k8s_global_vars.ssl_for_each_map.worker_instance_list_map
    name        = "${each.key}-${var.k8s_global_vars.cluster_name}"
    hostname    = format("%s.%s.%s", "${each.key}" ,var.k8s_global_vars.cluster_name, var.k8s_global_vars.base_domain)
    platform_id = "standard-v1"
    zone        = var.zone
    labels      = {
        "node-role.kubernetes.io/worker" = ""
    }
    resources {
        cores         = var.worker_flavor.core
        memory        = var.worker_flavor.memory
        core_fraction = var.worker_flavor.core_fraction
    }

    boot_disk {
        initialize_params {
        image_id = var.base_worker_os_image
        size = 20
        }
    }

    network_interface {
        subnet_id = yandex_vpc_subnet.worker-subnets[var.zone].id
        nat = true
    }

    lifecycle {
        ignore_changes = [
        metadata
        ]
    }

    metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = var.cloud_init_template.worker[each.key]
    }
}
    # 
# output "cloud_init_worker" {
#     value = "${yandex_compute_instance.worker.network_interface[*].nat_ip_address}"
# }
