variable "k8s-service-account" {
  type = map(object({
    name        = string
    description = string
  }))
  default = {
    "extra-args" = {
      name = "yandex-k8s-controllers"
      description = "service account to manage all in k8s clusters"
    }
  }
}

variable "cloud" {
  type = map(object({
    name        = optional(string, "")
    folder_name = optional(string, "")
  }))
  default = {
    "extra-args" = {
      folder_name = "example"
      name        = "cloud-uid-vf465ie7"
    }
  }
}
