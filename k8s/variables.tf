variable "vault_server" {
  type = string
  default = "http://vault.example.com/"
}


variable "base_domain" {
  type = string
  default = "example.com"
}

variable "yandex_cloud_name" {
  description = "module:K8S "
  type        = string
  default     = "example"
}

variable "yandex_folder_name" {
  description = "module:K8S "
  type        = string
  default     = "example"
}

variable "cidr" {
  type = object({
    service = string
    pod     = string
    node_cidr_mask = string
  })
  default = {
    service   = "172.16.0.0/16"
    pod       = "10.100.0.0/16"
    node_cidr_mask = "24"
  }
}

variable "default_zone" {
  type = string
  default = "ru-central1-a"
}

variable "default_subnet" {
  type = string
  default = "10.1.0.0/24"
}
variable "cluster_name" {
  type = string
  default = "default"
}
