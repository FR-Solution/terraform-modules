data "yandex_resourcemanager_cloud" "current" {
  name = var.yandex_cloud_name
}

data "yandex_resourcemanager_folder" "current" {
  name     = var.yandex_folder_name
  cloud_id = data.yandex_resourcemanager_cloud.current.id
}


#### VPC ######
##-->
resource "yandex_vpc_network" "cluster-vpc" {
  name = "vpc.clusters"
}

resource "yandex_vpc_route_table" "cluster-vpc-route-table" {
  name = "vpc.clusters.route.table"
  network_id = "${yandex_vpc_network.cluster-vpc.id}"
}

#### SUBNETS ######
##-->
resource "yandex_vpc_subnet" "master-subnets" {
    for_each = var.master_availability_zones
    
    v4_cidr_blocks  = [var.master_availability_zones[each.key]]
    zone            = each.key
    network_id      = yandex_vpc_network.cluster-vpc.id
    name            = "vpc-${var.cluster_name}-masters-${each.key}" 
    route_table_id = yandex_vpc_route_table.cluster-vpc-route-table.id
}

variable "master_availability_zones"{
  type = object({
    ru-central1-a = string
    ru-central1-b = string
    ru-central1-c = string
  })
  default = {
    ru-central1-a = "10.1.0.0/16"
    ru-central1-b = "10.2.0.0/16"
    ru-central1-c = "10.3.0.0/16"
  }
}

module "k8s-yandex-cluster" {
    source = "../modules/k8s-yandex-cluster"
    cluster_name    = var.cluster_name
    base_domain     = "dobry-kot.ru"
    vault_server    = "http://193.32.219.99:9200/"
    
    service_cidr    = "29.64.0.0/16"
    
    cloud_metadata = {
      folder_id = data.yandex_resourcemanager_folder.current.id
    }
    master_group = {
        name    = "master" # Разрешенный префикс для сертификатов.
        count   = 3

        vpc_id          = yandex_vpc_network.cluster-vpc.id
        default_subnet_id = yandex_vpc_subnet.master-subnets["ru-central1-a"].id
        default_zone      = "ru-central1-a"

        subnet_id_overwrite = {
            master-1 = {
                subnet  = yandex_vpc_subnet.master-subnets["ru-central1-a"].id
                zone    = "ru-central1-a"
            }
            master-2 = {
                subnet  = yandex_vpc_subnet.master-subnets["ru-central1-b"].id
                zone    = "ru-central1-b"
            }
            master-3 = {
                subnet  = yandex_vpc_subnet.master-subnets["ru-central1-c"].id
                zone    = "ru-central1-c"
            }
        }
        resources = {
          core            = 6
          memory          = 12
          core_fraction   = 100
          etcd_disk       = 10
          first_disk      = 30
        }
        os_image = "fd8kdq6d0p8sij7h5qe3"
        ssh_username = "dkot"
        ssh_rsa_path = "~/.ssh/id_rsa.pub"
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

locals {
    lb-kube-apiserver-ip = module.k8s-yandex-cluster.kube-apiserver-lb
}

output "LB-IP" {
    value = "kubectl config set-cluster  ${var.cluster_name} --server=https://${local.lb-kube-apiserver-ip} --insecure-skip-tls-verify"
}
