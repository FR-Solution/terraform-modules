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

variable "pod_cidr" {
  type = string
  default = "10.200.0.0/16"
}

variable "node_cidr_mask" {
  type = string
  default = "24"
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

variable "global_vars" {
  type = any
}
variable "master_group"{
  type = object({
    name = string
    count = number
    vpc_name = string
    route_table_name = string
    # subnets = any
    default_subnet = optional(string, "")
    default_zone = string
    resources_overwrite = any
    resources = any
    metadata = any
    # ssh_username = string
    # ssh_rsa_path = string

  })
  validation {
      condition = (
        contains([1,3,5], var.master_group.count) == true
      )
      error_message = "var.master_group.count is not correct. Number of master can be 1,3,5"
  }
  default = {
    name = "master"
    count = 0
    vpc_name = null
    # subnets = null
    route_table_name = ""
    default_subnet = "10.1.0.0/16"
    default_zone = "ru-central1-a"
    resources_overwrite = {}
    metadata = {}
    resources = {
      core = 4
      memory = 8
      core_fraction = 100
      disk = {}
      first_disk = 20
      etcd_disk = 60
    }
    # ssh_username = "dkot"
    # ssh_rsa_path = "~/.ssh/id_rsa"

  }
}
