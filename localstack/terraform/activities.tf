locals {
  activities_service_map = {
    name           = "cvs-localstack-activities",
    bucket_name    = "cvs-services",
    object_key     = "cvs-svc-activities/latest.zip",
    object_version = "localstack"
    handler        = "handler.handler",
    description    = "cvs-svc-activities",
    repo           = "cvs-svc-activities",
    runtime        = "nodejs14.x"
    timeout        = 30,
    memory         = 128
    hash_key       = "id"
    hash_type      = "S"
    additional_attributes = [
      {
        key  = "testerStaffId"
        type = "S"
      },
      {
        key  = "activityDay"
        type = "S"
      },
      {
        key  = "startTime"
        type = "S"
      }
    ]
    global_secondary_indexes = [
      {
        name            = "ActivityDayIndex"
        hash_key        = "activityDay"
        range_key       = "startTime"
        projection_type = "INCLUDE"

        non_key_attributes = [
          "testerStaffId",
          "testerName",
          "activityType",
          "endTime",
          "testerEmail",
          "id",
        ]
      },
      {
        name            = "StaffIndex"
        hash_key        = "testerStaffId"
        range_key       = null
        projection_type = "INCLUDE"

        non_key_attributes = [
          "testStationType",
          "startTime",
          "testerName",
          "activityType",
          "endTime",
          "testStationName",
          "testStationPNumber",
          "testStationEmail",
        ]
      }
    ]
  }
}

module activities_lambda {
  source                 = "./lambda"
  service_map            = local.activities_service_map
  lambda_exec_role_arn   = module.iam.lambda_exec_role_arn
  additional_env_vars = {
    BRANCH = "localstack"
  }
}

module activities_dynamo {
  source       = "./dynamodb"
  service_name = local.activities_service_map.name
  hash = {
    key  = local.activities_service_map.hash_key
    type = local.activities_service_map.hash_type
  }
  additional_attributes = local.activities_service_map.additional_attributes
  global_secondary_indexes = local.activities_service_map.global_secondary_indexes
}

resource aws_lambda_permission activities {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.activities_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:eu-west-1:000000000000:${module.api.apigw_id}/*/*/*"
}