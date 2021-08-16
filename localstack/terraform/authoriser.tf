locals {
  authoriser_service_map = {
    name           = "cvs-localstack-authoriser",
    bucket_name    = "cvs-services",
    object_key     = "cvs-svc-authoriser/latest.zip",
    object_version = "localstack"
    handler        = "handler.handler",
    description    = "cvs-svc-authoriser",
    repo           = "cvs-svc-authoriser",
    runtime        = "nodejs14.x"
    memory         = 128,
    timeout        = 30,
    hash_key       = "id"
    hash_type      = "N"
  }
}

module authoriser_lambda {
  source                 = "./lambda"
  service_map            = local.authoriser_service_map
  lambda_exec_role_arn   = module.iam.lambda_exec_role_arn
  additional_env_vars = {
    BRANCH = "localstack"
  }
}

resource aws_lambda_permission authoriser {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.authoriser_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:eu-west-1:000000000000:${module.api.apigw_id}/*/*/*"
}