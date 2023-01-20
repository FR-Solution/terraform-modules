
# variable "keycloak" {
#   description = "Map of Keycloak with their parameters"
#   type = map(object({
#     realm                     = optional(string, "master")
#     client_id                 = optional(string, "admin-cli")
#     username                  = string
#     password                  = string
#     url                       = string
#     root_ca_certificate       = optional(string, "")
#     tls_insecure_skip_verify  = optional(bool, true)

#   }))
#   default = {
#     "key" = {
#       username                  = ""
#       password                  = ""
#       url                       = ""
#     }
#   }
# }
locals {
  idp_provider_realm = "master"
}