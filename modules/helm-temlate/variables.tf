

variable "release_name" {
  type = string

}

variable "chart_repo" {
  type = string

}

variable "chart_name" {
  type = string

}

variable "chart_version" {
  type = string

}

variable "namespace" {
  type = string

}

variable "global_vars" {
  type = any
}

variable "extra_values" {
  type = any

}
