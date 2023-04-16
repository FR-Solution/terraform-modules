
variable "release_name" {
  type = string
  default = "victoria-metrics-k8s-stack"
}

variable "chart_repo" {
  type = string
  default = "https://victoriametrics.github.io/helm-charts/"
}

variable "chart_name" {
  type = string
  default = "victoria-metrics-k8s-stack"
}

variable "chart_version" {
  type = string
  default = "0.14.17"
}

variable "namespace" {
  type = string
  default = "kube-fraima-monitoring"
}

variable "global_vars" {
  type = any
}

variable "extra_values" {
  type = any
  default = {}
}
