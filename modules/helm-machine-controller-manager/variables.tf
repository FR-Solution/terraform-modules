
variable "release_name" {
  type = string
  default = "machine-controller-manager"
}

variable "chart_repo" {
  type = string
  default = "https://helm.fraima.io"
}

variable "chart_name" {
  type = string
  default = "cluster-machine-controller"
}

variable "chart_version" {
  type = string
  default = "0.0.3"
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
