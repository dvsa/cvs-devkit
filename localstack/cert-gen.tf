locals {
  cert_gen_service_map = {
    name           = "cvs-localstack-cert-gen",
    bucket_name    = "cvs-services",
    object_key     = "cvs-tsk-cert-gen/latest.zip",
    object_version = "localstack"
    handler        = "handler.handler",
    description    = "cvs-tsk-cert-gen",
    repo           = "cvs-tsk-cert-gen",
    runtime        = "nodejs14.x"
    timeout        = 30,
    memory         = 128
  }
}

module cert_gen_lambda {
  source                 = "./lambda"
  service_map            = local.cert_gen_service_map
  lambda_exec_role_arn   = module.iam.lambda_exec_role_arn
  additional_env_vars = {
    BRANCH = "localstack"
  }
}

resource aws_lambda_permission cert-gen {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.cert_gen_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:eu-west-1:000000000000:${module.api.apigw_id}/*/*/*"
}

resource aws_lambda_event_source_mapping cert_gen {
  batch_size       = 10
  event_source_arn = module.cert_gen_sqs.queue_arn
  enabled          = true
  function_name    = module.cert_gen_lambda.arn
}
