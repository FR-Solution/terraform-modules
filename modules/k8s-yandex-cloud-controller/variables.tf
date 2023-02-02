
variable "release_name" {
  type = string
  default = "yandex-cloud-controller"
}

variable "chart_repo" {
  type = string
  default = "https://helm.fraima.io"
}

variable "chart_name" {
  type = string
  default = "yandex-cloud-controller"
}

variable "chart_version" {
  type = string
  default = "0.0.3"
}

variable "yandex_cloud_controller_sa_name" {
  type = string
  default = "k8s-cloud-controller"
}

variable "yandex_default_vpc_name" {
  type = string
}

variable "yandex_default_route_table_name" {
  type = string
}

variable "namespace" {
  type = string
  default = "kube-fraima-ccm"
}

variable "global_vars" {
  type = any
}

variable "extra_values" {
  type = any
  default = ""
}
