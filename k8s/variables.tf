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
    service   = "172.16.0.0/16"
    pod       = "10.100.0.0/16"
    node_cidr_mask = "24"
  }
}
