
#### CONFIGS ######
##-->
variable "master_flavor" {
  type = object({
    core            = string
    memory          = string
    core_fraction   = string
    secondary_disk  = string
  })
  default = {
    core            = 4
    memory          = 8
    core_fraction   = 100
    secondary_disk  = 60
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

# # проверен переход
# # fd8dl9ahl649kf31vp4o | debian-10-v20220117
# # fd8kdq6d0p8sij7h5qe3 | ubuntu-20-04-lts-v20220822
# # fd83h3kff4ja27ejq0d9 | debian-11