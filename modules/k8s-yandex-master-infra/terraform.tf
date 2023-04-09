terraform {

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.81.0"
    }
    # sgroups = {
    #    version = "1.0.3"
    #    source = "fraima/charlotte"
    # }
  }
  required_version = ">= 0.13"

}
