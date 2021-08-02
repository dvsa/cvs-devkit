variable service_map {
  type = object({
    name           = string,
    bucket_name    = string,
    object_key     = string,
    handler        = string,
    description    = string,
    memory         = number,
    timeout        = number,
    runtime        = string

  })
  description = "Pass the service map from environment here, certain values will be stripped off as they are not used."
}

variable lambda_exec_role_arn {
  type        = string
  description = "Pass the lambda exec role arn here"
}

variable additional_env_vars {
  type        = map(string)
  default     = {}
  description = "A map of key value pairs for environment variables."
}
