variable service_name {
  type = string
}
variable visibility_timeout_seconds {
  type    = number
  default = 120
}
variable message_retention_seconds {
  type    = number
  default = 1209600
}
variable max_message_size {
  type    = number
  default = 262144
}
variable delay_seconds {
  type    = number
  default = 0
}
variable receive_wait_time_seconds {
  type    = number
  default = 0
}
variable fifo_queue {
  type    = bool
  default = false
}
variable content_based_deduplication {
  type    = bool
  default = false
}
variable policy {
  type    = string
  default = null
}
variable max_receive_count {
  type    = number
  default = 120
}
