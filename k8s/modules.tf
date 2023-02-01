module "k8s-yandex-cluster" {
    source = "../modules/k8s-yandex-cluster-infra"

    global_vars = {
      cluster_name    = var.cluster_name
      base_domain     = var.base_domain
      vault_server    = var.vault_server

      service_cidr    = var.cidr.service
      pod_cidr        = var.cidr.pod
      node_cidr_mask  = var.cidr.node_cidr_mask
      
      ssh_username  = "dkot"
      ssh_rsa_path  = "~/.ssh/id_rsa.pub"
    }

    cloud_metadata = {
      cloud_name  = var.yandex_cloud_name
      folder_name = var.yandex_folder_name
    }

    master_group = {
        name    = "master" # Разрешенный префикс для сертификатов.
        count   = 1

        vpc_name          = var.yandex_default_vpc_name
        route_table_name  = var.yandex_default_route_table_name

        default_subnet    = var.default_subnet
        default_zone      = var.default_zone

        resources_overwrite = {
            # master-1 = {
            #   network_interface = {
            #     zone    = "ru-central1-a"
            #     subnet  = "10.1.0.0/24"
            #   }

            # }
            # master-2 = {
            #   network_interface = {
            #     zone    = "ru-central1-b"
            #     subnet  = "10.2.0.0/24"
            #   }
            # }
            # master-3 = {
            #   network_interface = {
            #     zone    = "ru-central1-c"
            #     subnet  = "10.3.0.0/24"
            #   }
            # }
        }

        resources = {
          core            = 6
          memory          = 12
          core_fraction   = 100

          disk = {
            boot = {
              image_id  = "fd8kdq6d0p8sij7h5qe3"
              size      = 30
              type      = "network-hdd"
            }

            secondary_disk = {
              etcd = {
                size        = 10
                mode        = "READ_WRITE"
                auto_delete = false
                type        = "network-ssd"
              }
            }
          }
          network_interface = {
            nat = true
          }

        }
        metadata = {
          user_data_template = "fraima" # all | packer | fraima
        }

    }
}
