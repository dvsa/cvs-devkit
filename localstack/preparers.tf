locals {
  preparers_service_map = {
    name           = "cvs-localstack-preparers",
    bucket_name    = "cvs-services",
    object_key     = "cvs-svc-preparers/latest.zip",
    object_version = "localstack"
    handler        = "handler.handler",
    description    = "cvs-svc-preparers",
    repo           = "cvs-svc-preparers",
    runtime        = "nodejs14.x"
    timeout        = 30,
    memory         = 128
    hash_key       = "preparerId"
    hash_type      = "S"
  }
}

module preparers_lambda {
  source                 = "./lambda"
  service_map            = local.preparers_service_map
  lambda_exec_role_arn   = module.iam.lambda_exec_role_arn
  additional_env_vars = {
    BRANCH = "localstack"
  }
}

module preparers_dynamo {
  source       = "./dynamodb"
  service_name = local.preparers_service_map.name
  hash = {
    key  = local.preparers_service_map.hash_key
    type = local.preparers_service_map.hash_type
  }
}

resource aws_lambda_permission preparers {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.preparers_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:eu-west-1:000000000000:${module.api.apigw_id}/*/*/*"
}