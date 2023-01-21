variable "cloud" {
  type = map(object({
    name        = optional(string, "")
    folder_name = optional(string, "")
  }))
  default = {
    "extra-args" = {
      folder_name = "example"
      name        = "example"
    }
  }
}

variable "vpc" {
  type = map(object({
    name = optional(string, "")
  }))
  default = {
    "extra-args" = {
      name = "vpc-example"
    }
  }
}

variable "gateway" {
  type = map(object({
    name = optional(string, "")
  }))
  default = {
    "extra-args" = {
      name = "gw-example"
    }
  }
}

variable "route-table" {
  type = map(object({
    name = optional(string, "")
  }))
  default = {
    "extra-args" = {
      name = "route-table-example"
    }
  }
}
