variable "vault_server" {
  type = string
  default = "http://193.32.219.99:9200/"
}

variable "cluster_name" {
  type = string
  default = "default"
}

variable "base_domain" {
  type = string
  default = "dobry-kot.ru"
}

variable "yandex_cloud_name" {
  description = "module:K8S "
  type        = string
  default     = "cloud-uid-vf465ie7"
}

variable "yandex_folder_name" {
  description = "module:K8S "
  type        = string
  default     = "example"
}

variable "master_availability_zones"{
  type = object({
    ru-central1-a = string
    ru-central1-b = string
    ru-central1-c = string
  })
  default = {
    ru-central1-a = "10.1.0.0/16"
    ru-central1-b = "10.2.0.0/16"
    ru-central1-c = "10.3.0.0/16"
  }
}

variable "cidr" {
  type = object({
    service = string
    pod     = string
    node_cidr_mask = string
  })
  default = {
    service   = "29.64.0.0/16"
    pod       = "10.100.0.0/16"
    node_cidr_mask = "24"
  }
}

# variable "vault_config" {
#   type = object({
#     caBundle        = string
#     tlsInsecure     = bool
#   })
#   default = {
#     caBundle    = ""
#     tlsInsecure = true
#   }
# }

# variable "master-instance-count" {
#   type = number
#   default = 2
# }

# variable "worker-instance-count" {
#   type = number
#   default = 2
# }







# variable "base_os_image" {
#   type        = string
#   default     = "fd8kdq6d0p8sij7h5qe3"
# }

# variable "base_worker_os_image" {
#   type        = string
#   default     = "fd8kdq6d0p8sij7h5qe3"
# }

