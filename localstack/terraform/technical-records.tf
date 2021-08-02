locals {
  technical_records_service_map = {
    name           = "cvs-localstack-technical-records"
    bucket_name    = "cvs-services"
    object_key     = "cvs-svc-technical-records/latest.zip"
    object_version = "localstack"
    handler        = "handler.handler"
    description    = "cvs-svc-technical-records"
    repo           = "cvs-svc-technical-records"
    runtime        = "nodejs14.x"
    timeout        = 30
    memory         = 128
    range_key      = "vin"
    range_type     = "S"
    hash_key       = "systemNumber"
    hash_type      = "S"
    stream_enabled = false
    tec_additional_attributes = [
      {
        key  = "primaryVrm"
        type = "S"
      },
      {
        key  = "trailerId"
        type = "S"
      },
      {
        key  = "partialVin"
        type = "S"
      }
    ]
    tec_global_secondary_indexes = [
      {
        name            = "VRMIndex"
        hash_key        = "primaryVrm"
        projection_type = "INCLUDE"
        range_key       = null

        non_key_attributes = [
          "secondaryVrms",
          "vin",
          "techRecord",
        ]
      },
      {
        name            = "TrailerIdIndex"
        hash_key        = "trailerId"
        range_key       = null
        projection_type = "INCLUDE"

        non_key_attributes = [
          "secondaryVrms",
          "vin",
          "trailerId",
          "techRecord",
          "systemNumber",
          "primaryVrm",
        ]
      },
      {
        name            = "PartialVinIndex"
        hash_key        = "partialVin"
        range_key       = null
        projection_type = "INCLUDE"

        non_key_attributes = [
          "trailerId",
          "primaryVrm",
          "partialVin",
          "secondaryVrms",
          "vin",
          "techRecord",
          "systemNumber",
        ]
      },
      {
        name            = "VinIndex"
        hash_key        = "vin"
        range_key       = null
        projection_type = "INCLUDE"

        non_key_attributes = [
          "trailerId",
          "primaryVrm",
          "partialVin",
          "secondaryVrms",
          "vin",
          "techRecord",
          "systemNumber",
        ]
      },
      {
        name            = "SysNumIndex"
        hash_key        = "systemNumber"
        range_key       = null
        projection_type = "INCLUDE"

        non_key_attributes = [
          "trailerId",
          "primaryVrm",
          "partialVin",
          "secondaryVrms",
          "vin",
          "techRecord",
          "systemNumber",
        ]
      }
    ]
  }
}

module technical_records_lambda {
  source                 = "./lambda"
  service_map            = local.technical_records_service_map
  lambda_exec_role_arn   = module.iam.lambda_exec_role_arn
  additional_env_vars = {
    BRANCH = "localstack"
  }
}

module technical_records_dynamo {
  source       = "./dynamodb"
  service_name = local.technical_records_service_map.name
  hash = {
    key  = local.technical_records_service_map.hash_key
    type = local.technical_records_service_map.hash_type
  }
  range = {
    key  = local.technical_records_service_map.range_key
    type = local.technical_records_service_map.range_type
  }
  stream_enabled = local.technical_records_service_map.stream_enabled
  additional_attributes = local.technical_records_service_map.tec_additional_attributes
  global_secondary_indexes = local.technical_records_service_map.tec_global_secondary_indexes
}

resource aws_lambda_permission technical-records {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.technical_records_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:eu-west-1:000000000000:${module.api.apigw_id}/*/*/*"
}