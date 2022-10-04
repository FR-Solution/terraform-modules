
# resource "vault_pki_secret_backend_cert" "terrafor-kubeconfig" {
#   depends_on = [vault_pki_secret_backend_role.kubernetes-role]

#   backend = local.ssl.intermediate.kubernetes-ca.path
#   name = "kube-apiserver-kubelet-client"

#   common_name = "custom:terrafor-kubeconfig"
# }


# locals {
#   api_address = tolist(tolist(yandex_lb_network_load_balancer.api-internal.listener)[0].external_address_spec)[0].address
# }

# resource "null_resource" "cluster" {
#     for_each    = local.master_instance_list_map

#     triggers = {
#         cluster_instance_ids = join(",", yandex_compute_instance.master[*][each.key].id)
#     }

#     connection {
#         host        = element(yandex_compute_instance.master[*][each.key].network_interface.0.nat_ip_address, 0)
#         user        = "dkot"
#         type        = "ssh"
#         private_key = file("/home/dk/.ssh/id_rsa")
#         agent = "false"
#     }

#     provisioner "remote-exec" {
#         inline = [
#             "curl --connect-timeout 60000 -vk ${format("https://%s:6443", local.kube_apiserver_lb_fqdn)}"
#         ]
#     }
# }








# resource "helm_release" "certmanager" {
#   depends_on = [null_resource.cluster]
#   name       = "cert-manager"
#   repository = "https://charts.jetstack.io"
#   chart      = "cert-manager"
#   version    = "v1.9.1"
#   namespace  = "fraima-certmanager"
#   create_namespace  = true

#   set {
#     name  = "installCRDs"
#     value = true
#   }
#   set {
#     name  = "featureGates"
#     value = "ExperimentalCertificateSigningRequestControllers=true"
#   }
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

# # resource "kubernetes_manifest" "cluster-issuer-vault" {
# # #   depends_on = [kubernetes_secret.k8s-vault-approle]
# #   depends_on = [helm_release.certmanager]
# #   manifest = {
# #     "apiVersion" = "cert-manager.io/v1"
# #     "kind"       = "ClusterIssuer"
# #     "metadata" = {
# #       "name"      = "vault-issuer"
# #     }
# #     "spec" = {
# #       "vault" = {
# #         "path" = "${format("%s/sign/kubelet-peer-k8s-certmanager", local.ssl.intermediate.kubernetes-ca.path)}"
# #         "server" = var.vault_server
# #         "caBundle" = base64encode(vault_pki_secret_backend_cert.terrafor-kubeconfig.certificate)
# #         "auth" = {
# #             "appRole" = {
# #                 "path" = vault_auth_backend.approle.path
# #                 "roleId" = vault_approle_auth_backend_role.k8s-vault-role.role_id
# #                 "secretRef" = {
# #                     "name" = "cert-manager-vault-approle"
# #                     "key" = "secretId"
# #                 }
# #             }
# #         }
# #       }
# #     }
# #   }
# # }

# resource "kubernetes_secret" "k8s-vault-approle" {
#   depends_on = [helm_release.certmanager]
#   metadata {
#     name = "cert-manager-vault-approle"
#     namespace = "fraima-certmanager"
#     labels = {
#         sha = md5(base64encode(format("%s", vault_approle_auth_backend_role_secret_id.k8s-vault-secret.secret_id)))
#     }
#   }

#   data = {
#     secretId = format("%s", vault_approle_auth_backend_role_secret_id.k8s-vault-secret.secret_id)
#   }
#   type = "Opaque"
# }

# resource "kubernetes_role" "cert-manager-referencer" {
#     depends_on = [helm_release.certmanager]
#     metadata {
#         name = "terraform-cert-manager-referencer"
#         namespace = "fraima-certmanager"
#     }

#     rule {
#         api_groups     = ["cert-manager.io"]
#         resources      = ["signers"]
#         resource_names = ["*"]
#         verbs          = ["reference"]
#     }
# }


# # resource "helm_release" "gatekeeper" {
# #   depends_on = [yandex_compute_instance.master]
# #   name       = "gatekeeper"
# #   repository = "https://open-policy-agent.github.io/gatekeeper/charts"
# #   chart      = "gatekeeper"
# #   version    = "3.4.0"
# #   namespace  = "fraima-gatekeeper"
# #   create_namespace  = true

# #   set {
# #     name  = "customResourceDefinitions.create"
# #     value = true
# #   }

# # }

