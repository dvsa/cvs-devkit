locals {
  test_stations_service_map = {
    name           = "cvs-localstack-test-stations",
    bucket_name    = "cvs-services",
    object_key     = "cvs-svc-test-stations/latest.zip",
    object_version = "localstack"
    handler        = "handler.handler",
    description    = "cvs-svc-test-stations",
    repo           = "cvs-svc-test-stations",
    runtime        = "nodejs14.x"
    timeout        = 30,
    memory         = 128
    hash_key       = "testStationId"
    hash_type      = "S"
  }
}

module test_stations_lambda {
  source                 = "./lambda"
  service_map            = local.test_stations_service_map
  lambda_exec_role_arn   = module.iam.lambda_exec_role_arn
  additional_env_vars = {
    BRANCH = "localstack"
  }
}

module test_stations_dynamo {
  source       = "./dynamodb"
  service_name = local.test_stations_service_map.name
  hash = {
    key  = local.test_stations_service_map.hash_key
    type = local.test_stations_service_map.hash_type
  }
}

resource aws_lambda_permission test-stations {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.test_stations_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:eu-west-1:000000000000:${module.api.apigw_id}/*/*/*"
}