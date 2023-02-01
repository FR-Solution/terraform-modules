variable "vault_server" {
  type = string
}

variable "base_domain" {
  type = string

}

variable "yandex_cloud_name" {
  type = string

}

variable "yandex_folder_name" {
  type = string

}

variable "cidr" {
  type = object({
    service = string
    pod     = string
    node_cidr_mask = string
  })
}

variable "default_zone" {
  type = string
}

variable "default_subnet" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "yandex_default_vpc_name" {
  type = string
}

variable "yandex_default_route_table_name" {
  type = string
}

variable "yandex_cloud_controller_sa_name" {
  type = string
  default = "k8s-cloud-controller"

}