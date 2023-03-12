terraform {
  required_providers {
    sgroups = {
       version = "~> 1.0.0"
       source = "h-bf/sgroups"
    }
  }
}

provider "sgroups" {
  sgroups_address = "tcp://193.32.219.99:9000"
  sgroups_dial_duration = "20s"
}
