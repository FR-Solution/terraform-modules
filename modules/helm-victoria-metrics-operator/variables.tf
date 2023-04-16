
variable "release_name" {
  type = string
  default = "victoria-metrics-operator"
}

variable "chart_repo" {
  type = string
  default = "https://victoriametrics.github.io/helm-charts/"
}

variable "chart_name" {
  type = string
  default = "victoria-metrics-operator"
}

variable "chart_version" {
  type = string
  default = "0.18.0"
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
