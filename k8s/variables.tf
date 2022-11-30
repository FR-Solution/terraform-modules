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
  default = 2
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

variable "base_os_image" {
  type        = string
  default     = "fd8kdq6d0p8sij7h5qe3"
}

variable "base_worker_os_image" {
  type        = string
  default     = "fd8kdq6d0p8sij7h5qe3"
}

