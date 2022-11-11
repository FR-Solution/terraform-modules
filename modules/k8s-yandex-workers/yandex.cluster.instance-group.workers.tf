# resource "yandex_iam_service_account" "worker-sa" {

#   name        = "worker-group-test"
#   description = "service account to manage VMs in cloud ${var.k8s_global_vars.cluster_name}" 
# }



resource "yandex_iam_service_account" "ig-sa" {
  name        = "ig-sa"
  description = "service account to manage IG"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = "b1g7220ns3r5dts1lha3"
  role      = "editor"
  members   = [
    "serviceAccount:${yandex_iam_service_account.ig-sa.id}",
  ]
  depends_on = [
    yandex_iam_service_account.ig-sa,
  ]
}

resource "yandex_vpc_subnet" "worker-group-subnets" {

    v4_cidr_blocks  = ["172.16.10.0/24"]
    zone            = "ru-central1-a"
    network_id      = var.vpc-id
    name            = "vpc-${var.k8s_global_vars.cluster_name}-workers-g" 
}


resource "yandex_compute_instance_group" "group1" {
      depends_on = [yandex_iam_service_account.ig-sa]
  name                = "test-ig"
  folder_id           = "b1g7220ns3r5dts1lha3"
  service_account_id  = yandex_iam_service_account.ig-sa.id
  
  deletion_protection = false

  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
        mode = "READ_WRITE"
        initialize_params {
            image_id = var.base_worker_os_image
            size = 20
        }
    }

    network_interface {
      network_id = "${var.vpc-id}"
      subnet_ids = ["${yandex_vpc_subnet.worker-group-subnets.id}"]
      nat = true
    }

    metadata = {
        ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
        user-data = var.cloud_init_template.worker["worker-0"]
    }
    network_settings {
      type = "STANDARD"
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    zones = ["${var.zone}"]
  }

  deploy_policy {
    max_unavailable = 0
    max_creating    = 10
    max_expansion   = 10
    max_deleting    = 10
  }
}