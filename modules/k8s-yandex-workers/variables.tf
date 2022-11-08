

variable "k8s_global_vars" {
  description = "module:K8S-CERTIFICATE-VARS: base certificate vars"
  type        = any
  default     = {}
}


variable "cloud_init_template" {
  description = "module:K8S "
  type        = any
  default     = {}
}

variable "vpc-id" {
  type = any
  default = {}
}


variable "zone" {
  type = string
  default = "ru-central1-a"
}


#### CONFIGS ######
##-->
variable "worker_flavor" {
  type = object({
    core          = string
    memory        = string
    core_fraction = string
  })
  default = {
    core          = 2
    memory        = 4
    core_fraction = 20
  }
}

variable "base_worker_os_image" {
  type = string
  default = "fd8kdq6d0p8sij7h5qe3"
}

variable "worker_availability_zones"{
  type = object({
    ru-central1-a = string
    ru-central1-b = string
    ru-central1-c = string
  })
  default = {
    ru-central1-a = "10.11.0.0/16"
    ru-central1-b = "10.22.0.0/16"
    ru-central1-c = "10.33.0.0/16"
  }
}

# # проверен переход
# # fd8dl9ahl649kf31vp4o | debian-10-v20220117
# # fd8kdq6d0p8sij7h5qe3 | ubuntu-20-04-lts-v20220822
# # fd83h3kff4ja27ejq0d9 | debian-11