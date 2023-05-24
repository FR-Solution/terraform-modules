
module "k8s-global-vars" {
  source     = "../k8s-config-vars"
  extra_args = var.global_vars
}

module "k8s-vault" {
  depends_on = [
    module.k8s-global-vars
  ]
  source          = "../k8s-vault"
  k8s_global_vars = module.k8s-global-vars
}

module "k8s-vault-cluster" {
  depends_on = [
    module.k8s-vault
  ]
  source          = "../k8s-vault-cluster"
  k8s_global_vars = module.k8s-global-vars
}

module "k8s-vault-master" {
  depends_on = [
    module.k8s-vault-cluster,
  ]
  source = "../k8s-vault-master"
  k8s_global_vars   = module.k8s-global-vars
}

module "k8s-masters" {
  depends_on = [
    module.k8s-vault-master,
  ]
  source            = "../k8s-yandex-master-infra"

  k8s_global_vars   = module.k8s-global-vars
  cloud_metadata    = var.cloud_metadata
  k8s_vault_master  = module.k8s-vault-master
}

module "k8s-ready-status" {
  depends_on = [
    module.k8s-masters
  ]
  source            = "../k8s-ready-status"
  cluster_instances = module.k8s-masters.cluster_external_instances_map
  k8s_global_vars   = module.k8s-global-vars
}


module "addons" {

    source = "../k8s-addons"
    
    depends_on = [
        module.k8s-ready-status
    ]

    k8s_global_vars         = module.k8s-global-vars
    extra_values            = var.global_vars

}

module "k8s-masters-firewall" {
  count = try(var.global_vars.firewall.enabled, false) == true ? 1 : 0

  depends_on = [
    module.k8s-masters
  ]
  source                      = "../k8s-master-infra-firewall"
  cluster_instances_internal  = module.k8s-masters.cluster_internal_instances_map
  cluster_instances_external  = module.k8s-masters.cluster_external_instances_map
  cluster_api_ip              = try(module.k8s-masters.kube-apiserver-lb, "")
  k8s_global_vars             = module.k8s-global-vars
}
