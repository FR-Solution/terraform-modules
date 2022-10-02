terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "3.6.0"
    }
  }
  required_version = ">= 0.13"
  # experiments = [module_variable_optional_attrs]
}

provider "yandex" {
  token     = "AQAAAABFFfg7AATuwU6i6y1B3kleq9SiSZ8YFGg"
  cloud_id  = "bpfgrbrhbbg6e56ue4ol"
  folder_id = "b1g7220ns3r5dts1lha3"
  zone      = "ru-central1-a"
}

provider "vault" {
    address = "http://193.32.219.99:9200/"
    token = "hvs.rrZEynI1NWlZ01DKZ4lplbIO"
}

# configure keycloak provider
provider "keycloak" {
  realm                     = "master"
  client_id                      = "admin-cli"
  username                 = "admin"
  password                 = "dobrykot"
  url                      = "https://193.32.219.99"
  root_ca_certificate       = "/usr/local/share/ca-certificates/oidc-ca.pem"
  tls_insecure_skip_verify = true

}