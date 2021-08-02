variable service_name {
  type = string
}

variable hash {
  type = object({
    key  = string,
    type = string
  })
}
variable range {
  type = object({
    key  = string,
    type = string
  })
  default = {
    key  = null,
    type = null
  }
}

variable additional_attributes {
  type = list(object({
    key  = string,
    type = string
  }))
  default = []
}

variable stream_enabled {
  type    = bool
  default = false
}

variable global_secondary_indexes {
  type = list(object({
    name               = string,
    hash_key           = string
    range_key          = string
    projection_type    = string
    non_key_attributes = list(string)
  }))
  default = []
}
