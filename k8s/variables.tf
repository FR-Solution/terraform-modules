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
  default = 3
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


