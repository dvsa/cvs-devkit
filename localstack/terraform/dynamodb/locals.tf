locals {
  hash_attr = [{
    key  = var.hash.key
    type = var.hash.type
  }]
  range_attr = var.range.key != null ? [{
    key  = var.range.key
    type = var.range.type
  }] : []
  attributes = concat(local.hash_attr, local.range_attr, var.additional_attributes)
}