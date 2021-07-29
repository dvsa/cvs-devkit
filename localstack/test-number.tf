locals {
  test_number_service_map = {
    name           = "cvs-localstack-test-number",
    bucket_name    = "cvs-services",
    object_key     = "cvs-svc-test-number/latest.zip",
    object_version = "localstack"
    handler        = "handler.handler",
    description    = "cvs-svc-test-number",
    repo           = "cvs-svc-test-number",
    runtime        = "nodejs14.x"
    timeout        = 30,
    memory         = 128
    hash_key    = "testNumberKey"
    hash_type   = "N"
  }
}

module test_number_lambda {
  source                 = "./lambda"
  service_map            = local.test_number_service_map
  lambda_exec_role_arn   = module.iam.lambda_exec_role_arn
  additional_env_vars = {
    BRANCH = "localstack"
  }
}

module test_number_dynamo {
  source       = "./dynamodb"
  service_name = local.test_number_service_map.name
  hash = {
    key  = local.test_number_service_map.hash_key
    type = local.test_number_service_map.hash_type
  }
}

resource aws_lambda_permission test-number {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.test_number_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:eu-west-1:000000000000:${module.api.apigw_id}/*/*/*"
}