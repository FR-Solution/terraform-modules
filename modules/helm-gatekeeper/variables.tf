
variable "release_name" {
  type = string
  default = "gatekeeper"
}

variable "chart_repo" {
  type = string
  default = "https://open-policy-agent.github.io/gatekeeper/charts"
}

variable "chart_name" {
  type = string
  default = "gatekeeper"
}

variable "chart_version" {
  type = string
  default = "3.11.0"
}

variable "namespace" {
  type = string
  default = "kube-fraima-opa"
}

variable "global_vars" {
  type = any
}

variable "extra_values" {
  type = any
  default = {}
}
