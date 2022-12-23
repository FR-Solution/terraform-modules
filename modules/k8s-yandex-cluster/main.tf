
module "k8s-global-vars" {
    source = "../k8s-config-vars"
    cluster_name          = var.cluster_name
    base_domain           = var.base_domain
    vault_server          = var.vault_server
    service_cidr          = var.service_cidr
    ssh_username          = var.master_group.ssh_username
    ssh_rsa_path          = var.master_group.ssh_rsa_path
    pod_cidr              = var.pod_cidr
    node_cidr_mask        = var.node_cidr_mask
}

module "k8s-vault" {
    source = "../k8s-vault"
    k8s_global_vars   = module.k8s-global-vars
}

module "k8s-yandex-master-infra" {
    depends_on = [
      module.k8s-vault,
    ]
    source                  = "../k8s-yandex-master-infra"
    k8s_global_vars         = module.k8s-global-vars

    master_group = var.master_group
    cloud_metadata = var.cloud_metadata

}
