

variable "k8s_global_vars" {
  description = "module:K8S-CERTIFICATE-VARS: base certificate vars"
  type        = any
  default     = {}
}

variable "k8s_vault_master" {
  type = object({
    secret_id_all = any
    role_id_all   = any
  })
  default = {
    secret_id_all = null
    role_id_all   = null
  }
}

variable "cloud_metadata" {
  type = object({
    cloud_name = string
    folder_name = string
  })
  default = {
    cloud_name = null
    folder_name = null
  }
}

# variable "master_group"{
#   type = object({
#     name = string
#     count = number
#     vpc_name = string
#     route_table_name = string
#     # subnets = any
#     default_subnet  = optional(string, "")
#     default_zone    = optional(string, "")
#     resources_override = any
#     resources = any
#     metadata = any
#   })
#   default = {
#     name = "master"
#     count = 0
#     vpc_name = null
#     # subnets = null
#     default_subnet = null
#     route_table_name = ""
#     default_zone = "ru-central1-a"
#     resources_override = {}
#     metadata = {}
#     resources = {
#       core = 4
#       memory = 8
#       core_fraction = 100
#       disk = {}
#     }
#   }
# }
