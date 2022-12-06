variable "cluster_name" {
  type = string
  default = ""
}

variable "base_domain" {
  type = string
  default = ""
}

variable "vault_server" {
  type = string
  default = ""
}

variable "service_cidr" {
  type = string
  default = "172.16.0.0/16"
}

variable "master_group"{
  type = object({
    name = string
    count = number
    vpc_id = string
    default_subnet_id = string
    default_zone = string
    subnet_id_overwrite = any
    resources = any
    os_image = string

  })
  default = {
    name = "master"
    count = 0
    vpc_id = null
    default_subnet_id = null
    default_zone = "ru-central1-a"
    subnet_id_overwrite = {}
    resources = {
      core = 4
      memory = 8
      core_fraction = 100
      first_disk = 20
      etcd_disk = 60
    }
    os_image = "fd8kdq6d0p8sij7h5qe3"
  }
}
