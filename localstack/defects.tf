locals {
  defects_service_map = {
    name           = "cvs-localstack-defects",
    bucket_name    = "cvs-services",
    object_key     = "cvs-svc-defects/latest.zip",
    object_version = "localstack"
    handler        = "handler.handler",
    description    = "cvs-svc-defects",
    repo           = "cvs-svc-defects",
    runtime        = "nodejs14.x"
    memory         = 128,
    timeout        = 30,
    hash_key       = "id"
    hash_type      = "N"
  }
}

module defects_lambda {
  source                 = "./lambda"
  service_map            = local.defects_service_map
  lambda_exec_role_arn   = module.iam.lambda_exec_role_arn
  additional_env_vars = {
    BRANCH = "localstack"
  }
}

module defects_dynamo {
  source       = "./dynamodb"
  service_name = local.defects_service_map.name
  hash = {
    key  = local.defects_service_map.hash_key
    type = local.defects_service_map.hash_type
  }
}

resource aws_lambda_permission defects {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.defects_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:eu-west-1:000000000000:${module.api.apigw_id}/*/*/*"
}