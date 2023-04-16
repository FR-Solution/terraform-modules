
variable "release_name" {
  type = string
  default = "cert-manager"
}

variable "chart_repo" {
  type = string
  default = "https://charts.jetstack.io"
}

variable "chart_name" {
  type = string
  default = "cert-manager"
}

variable "chart_version" {
  type = string
  default = "v1.9.1"
}

variable "namespace" {
  type = string
  default = "kube-fraima-certmanager"
}

variable "global_vars" {
  type = any
}

variable "extra_values" {
  type = any
  default = {}
}
