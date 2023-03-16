terraform {
  backend "local" {
    workspace_dir = "states"
  }
  
  required_providers {
    sgroups = {
       version = "~> 1.0.0"
       source = "h-bf/sgroups"
    }
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.81.0"
    }
  }
}

provider "sgroups" {
  sgroups_address = "tcp://193.32.219.99:9000"
  sgroups_dial_duration = "20s"
}


provider "yandex" {
  token     = var.YC_TOKEN
  cloud_id  = var.YC_CLOUD_ID
  folder_id = var.YC_FOLDER_ID
  zone      = var.YC_ZONE
}
