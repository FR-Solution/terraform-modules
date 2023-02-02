
locals {
  master_group = {
    name              = "master"
    count             = 0
    route_table_name  = null
    vpc_name          = null
    default_subnet    = "10.0.0.0/24"
    default_zone      = "ru-central1-a"

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
      core          = 6
      memory        = 12
      core_fraction = 100
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

  master_group_merge = merge(local.master_group, var.master_group)
}
