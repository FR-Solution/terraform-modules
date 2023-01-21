variable "cloud" {
  type = map(object({
    name        = optional(string, "")
    folder_name = optional(string, "")
  }))
  default = {
    "key" = {
      folder_name = "example"
      name        = "cloud-uid-vf465ie7"
    }
  }
}

variable "vpc" {
  type = map(object({
    name = optional(string, "")
  }))
  default = {
    "key" = {
      name = "vpc-example"
    }
  }
}

variable "gateway" {
  type = map(object({
    name = optional(string, "")
  }))
  default = {
    "key" = {
      name = "gw-example"
    }
  }
}

variable "route-table" {
  type = map(object({
    name = optional(string, "")
  }))
  default = {
    "key" = {
      name = "vpc-example-route-table-example"
    }
  }
}
