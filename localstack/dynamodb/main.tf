resource aws_dynamodb_table db {
  name = var.service_name

  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = var.hash.key
  range_key        = var.range.key
  stream_enabled   = false
  stream_view_type = null

  dynamic attribute {
    for_each = local.attributes
    content {
      name = attribute.value["key"]
      type = attribute.value["type"]
    }
  }

  dynamic global_secondary_index {
    for_each = var.global_secondary_indexes
    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      range_key          = global_secondary_index.value.range_key
      non_key_attributes = global_secondary_index.value.non_key_attributes
      projection_type    = global_secondary_index.value.projection_type
    }
  }

  tags = {
    Environment = terraform.workspace
  }
}