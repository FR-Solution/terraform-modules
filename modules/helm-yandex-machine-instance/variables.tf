
variable "release_name" {
  type = string
  default = "yandex-compute-instance"
}

variable "chart_repo" {
  type = string
  default = "https://helm.fraima.io"
}

variable "chart_name" {
  type = string
  default = "machine-group"
}

variable "chart_version" {
  type = string
  default = "0.1.11"
}

variable "namespace" {
  type = string
  default = "kube-fraima-machine-controller-manager"
}

variable "global_vars" {
  type = any
}

variable "extra_values" {
  type = any
  default = {}
}

variable "custom_values" {
  type = any
  default = {}
}

variable "yandex_cloud_controller_sa_name" {
  type = string
  default = "k8s-cloud-controller"
}