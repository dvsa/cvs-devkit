locals {
  test_results_service_map = {
    name           = "cvs-localstack-test-results"
    bucket_name    = "cvs-services"
    object_key     = "cvs-svc-test-results/latest.zip"
    object_version = "localstack"
    handler        = "handler.handler"
    description    = "cvs-svc-test-results"
    repo           = "cvs-svc-test-results"
    runtime        = "nodejs14.x"
    timeout        = 60
    memory         = 512
    hash_key       = "vin"
    hash_type      = "S"
    range_key      = "testResultId"
    range_type     = "S"
    stream_enabled = true
    tsr_additional_attributes = [
      {
        key  = "systemNumber"
        type = "S"
      },
      {
        key  = "testerStaffId"
        type = "S"
      },
    ]
    tsr_global_secondary_indexes = [
      {
        name            = "TesterStaffIdIndex"
        hash_key        = "testerStaffId"
        range_key       = null
        projection_type = "INCLUDE"

        non_key_attributes = [
          "noOfAxles",
          "trailerId",
          "vrm",
          "numberOfSeats",
          "testStationPNumber",
          "testStartTimestamp",
          "preparerId",
          "testEndTimestamp",
          "vehicleType",
          "testStatus",
          "systemNumber",
          "testTypes",
        ]
      },
      {
        name            = "VinIndex"
        hash_key        = "vin"
        range_key       = null
        projection_type = "INCLUDE"

        non_key_attributes = [
          "secondaryVrms",
          "partialVin",
          "trailerId",
          "techRecord",
          "systemNumber",
          "primaryVrm",
        ]
      },
      {
        name               = "SysNumIndex"
        hash_key           = "systemNumber"
        range_key          = null
        projection_type    = "ALL"
        non_key_attributes = null
      },
    ]
  }
}

module test_results_lambda {
  source                 = "./lambda"
  service_map            = local.test_results_service_map
  lambda_exec_role_arn   = module.iam.lambda_exec_role_arn
  additional_env_vars = {
    BRANCH = "localstack"
  }
}

module test_results_dynamo {
  source       = "./dynamodb"
  service_name = local.test_results_service_map.name
  hash = {
    key  = local.test_results_service_map.hash_key
    type = local.test_results_service_map.hash_type
  }
  range = {
    key  = local.test_results_service_map.range_key
    type = local.test_results_service_map.range_type
  }
  stream_enabled = local.test_results_service_map.stream_enabled
  additional_attributes = local.test_results_service_map.tsr_additional_attributes
  global_secondary_indexes = local.test_results_service_map.tsr_global_secondary_indexes
}

resource aws_lambda_permission test-results {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.test_results_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:eu-west-1:000000000000:${module.api.apigw_id}/*/*/*"
}

resource aws_lambda_event_source_mapping cert_gen_init {
  batch_size        = 10
  event_source_arn  = module.test_results_dynamo.stream_arn
  function_name     = module.cert_gen_init_lambda.arn
  starting_position = "LATEST"
}