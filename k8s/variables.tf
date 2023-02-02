variable "global_vars" {
  type = any
}

variable "cloud_metadata" {
  type = any
}

variable "master_group"{
  type = any
  validation {
      condition = (
        contains([1,3,5], var.master_group.count) == true
      )
      error_message = "var.master_group.count is not correct. Number of master can be 1,3,5"
  }
}

variable "yandex_cloud_controller_sa_name" {
  type = string
  default = "k8s-cloud-controller"
}