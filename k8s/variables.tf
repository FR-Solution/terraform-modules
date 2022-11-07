variable "vault_server" {
  type = string
  default = ""
}

variable "vault_config" {
  type = object({
    caBundle        = string
    tlsInsecure     = bool
  })
  default = {
    caBundle    = ""
    tlsInsecure = true
  }
}

variable "master-instance-count" {
  type = number
  default = 1
}

variable "worker-instance-count" {
  type = number
  default = 0
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

