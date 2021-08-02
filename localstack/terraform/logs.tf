locals {
  logs_service_map = {
    name           = "cvs-localstack-logs",
    bucket_name    = "cvs-services",
    object_key     = "cvs-svc-app-logs/latest.zip",
    object_version = "localstack"
    handler        = "handler.handler",
    description    = "cvs-svc-app-logs",
    repo           = "cvs-svc-app-logs",
    runtime        = "nodejs14.x"
    memory         = 128,
    timeout        = 30
  }
}

module logs_lambda {
  source                 = "./lambda"
  service_map            = local.logs_service_map
  lambda_exec_role_arn   = module.iam.lambda_exec_role_arn
  additional_env_vars = {
    BRANCH = "localstack"
  }
}

resource aws_lambda_permission logs {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.logs_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:eu-west-1:000000000000:${module.api.apigw_id}/*/*/*"
}