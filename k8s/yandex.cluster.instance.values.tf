
#### CONFIGS ######
##-->
variable "master_flavor" {
  type = object({
    core          = string
    memory        = string
    core_fraction = string
  })
  default = {
    core          = 4
    memory        = 8
    core_fraction = 100
  }
}

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

variable "base_os_image" {
  type = string
  default = "fd8kdq6d0p8sij7h5qe3"
}
