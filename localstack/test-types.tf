locals {
  test_types_service_map = {
    name           = "cvs-localstack-test-types",
    bucket_name    = "cvs-services",
    object_key     = "cvs-svc-test-types/latest.zip",
    object_version = "localstack"
    handler        = "handler.handler",
    description    = "cvs-svc-test-types",
    repo           = "cvs-svc-test-types",
    runtime        = "nodejs14.x"
    memory         = 128,
    timeout        = 30,
    range_key   = "name"
    range_type  = "S"
    hash_key    = "id"
    hash_type   = "S"
  }
}

module test_types_lambda {
  source                 = "./lambda"
  service_map            = local.test_types_service_map
  lambda_exec_role_arn   = module.iam.lambda_exec_role_arn
  additional_env_vars = {
    BRANCH = "localstack"
  }
}

module test_types_dynamo {
  source       = "./dynamodb"
  service_name = local.test_types_service_map.name
  hash = {
    key  = local.test_types_service_map.hash_key
    type = local.test_types_service_map.hash_type
  }
  range = {
    key  = local.test_types_service_map.range_key
    type = local.test_types_service_map.range_type
  }
}

resource aws_lambda_permission test_types {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.test_types_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:eu-west-1:000000000000:${module.api.apigw_id}/*/*/*"
}