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