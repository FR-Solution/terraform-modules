
variable "release_name" {
  type = string
  default = "base-roles"
}

variable "chart_repo" {
  type = string
  default = "https://helm.fraima.io"
}

variable "chart_name" {
  type = string
  default = "base-roles"
}

variable "chart_version" {
  type = string
  default = "0.0.1"
}

variable "namespace" {
  type = string
  default = "kube-system"
}

variable "global_vars" {
  type = any
}

variable "extra_values" {
  type = any
  default = {}
}
