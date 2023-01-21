
# locals {
#   idp_provider_realm = "master"
# }

# resource "keycloak_openid_client" "kube" {
#   depends_on = [
#     module.k8s-yandex-cluster
#   ]
#   realm_id                     = local.idp_provider_realm
#   client_id                    = "kubernetes-${var.cluster_name}"
#   name                         = "kubernetes-${var.cluster_name}"
#   enabled                      = true
#   access_type                  = "CONFIDENTIAL"
#   client_secret                = "kube-client-secret"
#   standard_flow_enabled        = false
#   implicit_flow_enabled        = false
#   direct_access_grants_enabled = true
# }

# # configure kube openid client default scopes
# resource "keycloak_openid_client_default_scopes" "kube" {
#   realm_id  = local.idp_provider_realm
#   client_id = keycloak_openid_client.kube.id
#   default_scopes = [
#     "email",
#     "groups",
#   ]
# }