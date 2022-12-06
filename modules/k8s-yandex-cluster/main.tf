
module "k8s-global-vars" {
    source = "../k8s-config-vars"
    cluster_name          = var.cluster_name
    base_domain           = var.base_domain
    vault_server          = var.vault_server
    service_cidr          = var.service_cidr
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
    vault_policy_kubernetes_sign_approle = module.k8s-vault.vault-policy_kubernetes-sign-approle
}
