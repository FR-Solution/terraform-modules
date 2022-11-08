
#### CONFIGS ######
##-->

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

variable "default_master_zone" {
  description = "module:K8S "
  type        = string
  default     = "ru-central1-a"
}

variable "master_zones"{
  type = any
  default = {}
}