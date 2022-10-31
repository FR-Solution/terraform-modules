
module "k8s-global-vars" {
    source = "../modules/k8s-config-vars"
    cluster_name          = var.cluster_name
    base_domain           = var.base_domain
    master_instance_count = var.master-instance-count
    worker_instance_count = var.worker-instance-count
    vault_server          = var.vault_server
}

module "k8s-vault" {
    source = "../modules/k8s-vault"
    k8s_global_vars   = module.k8s-global-vars

}

module "k8s-cloud-init" {
    source                       = "../modules/k8s-templates/cloud-init"
    k8s_global_vars              = module.k8s-global-vars
    vault-bootstrap-master-token = module.k8s-vault.bootstrap-master-token
}

module "k8s-infrastructure" {
    
    source                  = "../modules/k8s-yandex-infrastructure"
    k8s_global_vars         = module.k8s-global-vars
    cloud_init_template     = module.k8s-cloud-init.master

    master_availability_zones = {
        ru-central1-a = "10.100.0.0/24"
        ru-central1-b = "10.101.0.0/24"
        ru-central1-c = "10.102.0.0/24"
    }

    worker_availability_zones = {
        ru-central1-a = "172.16.1.0/24"
        ru-central1-b = "172.16.2.0/24"
        ru-central1-c = "172.16.3.0/24"
    }

    master_zones = {
        master-1 = "ru-central1-b"
        master-2 = "ru-central1-c"
    }
}

locals {
    lb-kube-apiserver-ip = module.k8s-infrastructure.kube-apiserver-lb
}

