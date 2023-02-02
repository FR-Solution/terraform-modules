
variable "release_name" {
  type = string
  default = "yandex-csi-controller"
}

variable "chart_repo" {
  type = string
  default = "https://helm.fraima.io"
}

variable "chart_name" {
  type = string
  default = "yandex-csi-controller"
}

variable "chart_version" {
  type = string
  default = "0.0.4"
}

variable "yandex_cloud_controller_sa_name" {
  type = string
  default = "k8s-csi-controller"
}

variable "namespace" {
  type = string
  default = "kube-fraima-csi"
}

variable "global_vars" {
  type = any
}

variable "extra_values" {
  type = any
  default = {}
}
