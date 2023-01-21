terraform {

  backend "local" {
    workspace_dir = "states"
  }

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.81.0"
    }
  }
  required_version = ">= 0.13"
}
