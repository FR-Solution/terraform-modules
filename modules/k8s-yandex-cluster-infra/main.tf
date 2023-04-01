
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

module "k8s-masters" {
    depends_on = [
      module.k8s-vault,
    ]
    source                  = "../k8s-yandex-master-infra"
    k8s_global_vars         = module.k8s-global-vars

    master_group    = var.master_group
    cloud_metadata  = var.cloud_metadata
}

module "k8s-masters-firewall" {
  count = var.global_vars.firewall.enabled == true ? 1 : 0

  depends_on = [
    module.k8s-masters
  ]
  source = "../k8s-master-infra-firewall"
  cluster_instances = module.k8s-masters.cluster_internal_instances_map
  k8s_global_vars   = module.k8s-global-vars
}

module "k8s-ready-status" {
  depends_on = [
    module.k8s-masters
  ]
  source = "../k8s-ready-status"
  cluster_instances = module.k8s-masters.cluster_external_instances_map
  k8s_global_vars   = module.k8s-global-vars
}
