
module "k8s-global-vars" {
    source = "../modules/k8s-config-vars"
    cluster_name          = var.cluster_name
    base_domain           = var.base_domain
    vault_server          = var.vault_server
}

module "k8s-vault" {
    source = "../modules/k8s-vault"
    k8s_global_vars   = module.k8s-global-vars
}


# resource "vault_pki_secret_backend_cert" "terraform-kubeconfig" {
#     depends_on = [
#       module.k8s-vault
#     ]

#     backend       = module.k8s-global-vars.ssl.intermediate.kubernetes-ca.path
#     name          = "kube-apiserver-cluster-admin-client"
#     common_name   = "custom:terraform-kubeconfig"
# }

module "k8s-control-plane" {
    depends_on = [
      module.k8s-vault,
    ]
    source                  = "../modules/k8s-yandex-control-plane"
    k8s_global_vars         = module.k8s-global-vars

    # base_os_image         = "fd8dl9ahl649kf31vp4o"

    master_availability_zones = {
        ru-central1-a = "10.100.0.0/24"
        ru-central1-b = "10.101.0.0/24"
        ru-central1-c = "10.102.0.0/24"
    }

    master_zones = {
        master-1 = "ru-central1-a"
        master-2 = "ru-central1-b"
        master-3 = "ru-central1-c"
    }
    master-instance-count = 3

    vault_policy_kubernetes_sign_approle = module.k8s-vault.vault-policy_kubernetes-sign-approle
}

# module "k8s-data-plane" {
#     depends_on = [
#         module.k8s-control-plane,
#         helm_release.gatekeeper,
#         helm_release.certmanager
#     ]
#     source                  = "../modules/k8s-yandex-workers"
#     k8s_global_vars         = module.k8s-global-vars
#     cloud_init_template     = module.k8s-cloud-init
#     vpc-id                  = module.k8s-control-plane.vpc-id
    
#     # base_worker_os_image  = "fd8dl9ahl649kf31vp4o"

#     worker_availability_zones = {
#         ru-central1-a = "172.16.1.0/24"
#         ru-central1-b = "172.16.2.0/24"
#         ru-central1-c = "172.16.3.0/24"
#     }

#     zone = "ru-central1-a"

# }

# locals {
#     lb-kube-apiserver-ip = module.k8s-control-plane.kube-apiserver-lb
# }


# output "LB-IP" {
#     value = "kubectl config set-cluster  ${module.k8s-global-vars.cluster_name} --server=https://${local.lb-kube-apiserver-ip} --insecure-skip-tls-verify"
  
# }
