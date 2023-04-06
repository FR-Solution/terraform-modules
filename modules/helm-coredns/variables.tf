
variable "release_name" {
  type = string
  default = "coredns"
}

variable "chart_repo" {
  type = string
  default = "https://coredns.github.io/helm"
}

variable "chart_name" {
  type = string
  default = "coredns"
}

variable "chart_version" {
  type = string
  default = "1.19.4"
}

variable "namespace" {
  type = string
  default = "kube-fraima-dns"
}

variable "global_vars" {
  type = any
}

variable "extra_values" {
  type = any
  default = {}
}
