
# resource "vault_pki_secret_backend_cert" "terrafor-kubeconfig" {
#   depends_on = [vault_pki_secret_backend_role.kubernetes-role]

#   backend = "/clusters/cluster-1/pki/kubernetes"
#   name = "kube-apiserver-kubelet-client"

#   common_name = "custom:terrafor-kubeconfig"
# }

# provider "kubernetes" {
#   host = format("https://%s:6443", local.api_address)

#   client_certificate     = vault_pki_secret_backend_cert.terrafor-kubeconfig.certificate
#   client_key             = vault_pki_secret_backend_cert.terrafor-kubeconfig.private_key
#   cluster_ca_certificate = vault_pki_secret_backend_cert.terrafor-kubeconfig.issuing_ca
# }

# locals {
#   api_address = tolist(tolist(yandex_lb_network_load_balancer.api-internal.listener)[0].external_address_spec)[0].address
# }

# resource "null_resource" "cluster" {
#     for_each    = "${local.master_instance_list_map}"

#     triggers = {
#         cluster_instance_ids = join(",", yandex_compute_instance.master[*][each.key].id)
#     }

#     connection {
#         host        = element(yandex_compute_instance.master[*][each.key].network_interface.0.nat_ip_address, 0)
#         user        = "dkot"
#         type        = "ssh"
#         private_key = file("/home/dk/.ssh/id_rsa")
#     }

#     provisioner "local-exec" {
#         command = "curl --connect-timeout 6000 -vk ${format("https://%s:6443", local.api_address)}"
#     }
# }


# resource "vault_approle_auth_backend_role" "k8s-vault-role" {
#   backend         = vault_auth_backend.approle.path
#   role_name       = "kubelet-peer-k8s-certmanager"
#   token_policies  = ["clusters/cluster-1/certificates/kubelet-peer-k8s-certmanager"]
# }

# resource "vault_approle_auth_backend_role_secret_id" "k8s-vault-secret" {
#   backend   = vault_auth_backend.approle.path
#   role_name = vault_approle_auth_backend_role.k8s-vault-role.role_name
# }

# resource "kubernetes_manifest" "cluster-issuer-vault" {
# #   depends_on = [kubernetes_secret.k8s-vault-approle]
#   depends_on = [null_resource.cluster]
#   manifest = {
#     "apiVersion" = "cert-manager.io/v1"
#     "kind"       = "ClusterIssuer"
#     "metadata" = {
#       "name"      = "vault-issuer"
#     }
#     "spec" = {
#       "vault" = {
#         "path" = "${format("%s/sign/kubelet-peer-k8s-certmanager", local.ssl.intermediate.kubernetes-ca.path)}"
#         "server" = var.vault_server
#         "caBundle" = base64encode(vault_pki_secret_backend_cert.terrafor-kubeconfig.certificate)
#         "auth" = {
#             "appRole" = {
#                 "path" = vault_auth_backend.approle.path
#                 "roleId" = vault_approle_auth_backend_role.k8s-vault-role.role_id
#                 "secretRef" = {
#                     "name" = "cert-manager-vault-approle"
#                     "key" = "secretId"
#                 }
#             }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_secret" "k8s-vault-approle" {
#   depends_on = [null_resource.cluster]
#   metadata {
#     name = "cert-manager-vault-approle"
#     namespace = "pfm-certmanager"
#     labels = {
#         sha = md5(base64encode(format("%s", vault_approle_auth_backend_role_secret_id.k8s-vault-secret.secret_id)))
#     }
#   }

#   data = {
#     secretId = format("%s", vault_approle_auth_backend_role_secret_id.k8s-vault-secret.secret_id)
#   }
#   type = "Opaque"
# }


