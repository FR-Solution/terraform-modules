terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
  # experiments = [module_variable_optional_attrs]
}

provider "yandex" {
  token     = ""
  cloud_id  = ""
  folder_id = ""
  zone      = ""
}

provider "vault" {
    address = ""
    token = ""
}

