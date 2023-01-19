
module "k8s-global-vars" {
    source = "../k8s-config-vars"
    extra_args = var.global_vars
}

module "k8s-vault" {
    depends_on = [
      module.k8s-global-vars
    ]
    source = "../k8s-vault"
    k8s_global_vars   = module.k8s-global-vars
}

module "k8s-vault-cluster" {
    depends_on = [
      module.k8s-vault
    ]
    source = "../k8s-vault-cluster"
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
