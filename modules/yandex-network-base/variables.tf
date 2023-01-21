variable "cloud" {
  type = map(object({
    name = string
    folder_name = string
  }))
  default = {
    "key" = {
      folder_name = "example"
      name = "cloud-uid-vf465ie7"
    }
  }
}

variable "vpc" {
  type = map(object({
    name = string
  }))
  default = {
    "key" = {
      name = "vpc-example"
    }
  }
}

variable "gateway" {
  type = map(object({
    name = string
  }))
  default = {
    "key" = {
      name = "gw-example"
    }
  }
}

variable "route-table" {
  type = map(object({
    name = string
  }))
  default = {
    "key" = {
      name = "vpc-example-route-table-example"
    }
  }
}
