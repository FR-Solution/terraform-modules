
variable "release_name" {
  type = string
  default = "cilium"
}

variable "chart_repo" {
  type = string
  default = "https://helm.cilium.io"
}

variable "chart_name" {
  type = string
  default = "cilium"
}

variable "chart_version" {
  type = string
  default = "1.12.0"
}

variable "namespace" {
  type = string
  default = "kube-fraima-sdn"
}

variable "global_vars" {
  type = any
}

variable "extra_values" {
  type = any
  default = {}
}

variable "cluster_id" {
  type = string
}