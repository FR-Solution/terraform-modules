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
      cloud_name  = "cloud-uid-vf465ie7"
      folder_name = "example"
    }

    master_group = {
        name    = "master" # Разрешенный префикс для сертификатов.
        count   = 1

        vpc_name          = "vpc.clusters"
        route_table_name  = "vpc-clusters-route-table"
        # subnets           = yandex_vpc_subnet.master-subnets
        default_subnet    = "10.1.0.0/16"
        default_zone      = "ru-central1-a"

        resources_overwrite = {
            master-1 = {
              zone    = "ru-central1-a"
              subnet  = "10.1.0.0/16"
            }
            master-2 = {
              zone    = "ru-central1-b"
              subnet  = "10.2.0.0/16"
            }
            master-3 = {
              # zone    = "ru-central1-c"
              # subnet  = "10.4.0.0/16"
            }
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

resource "vault_pki_secret_backend_cert" "terraform-kubeconfig" {
  depends_on = [
    module.k8s-yandex-cluster
  ]
    backend       = module.k8s-yandex-cluster.k8s_global_vars.ssl.intermediate.kubernetes-ca.path
    name          = "kube-apiserver-cluster-admin-client"
    common_name   = "custom:terraform-kubeconfig"
}

# locals {
#     lb-kube-apiserver-ip = module.k8s-yandex-cluster.kube-apiserver-lb
# }

output "DEBUGER" {
  value = module.k8s-yandex-cluster.DEBUGER
}


# output "LB-IP" {
#     value = "kubectl config set-cluster  ${var.cluster_name} --server=https://${local.lb-kube-apiserver-ip} --insecure-skip-tls-verify"
# }
