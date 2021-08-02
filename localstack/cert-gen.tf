locals {
  certificate_generation_service_map = {
    name           = "cvs-localstack-certificate-generation",
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

module certificate_generation_lambda {
  source                 = "./lambda"
  service_map            = local.certificate_generation_service_map
  lambda_exec_role_arn   = module.iam.lambda_exec_role_arn
  additional_env_vars = {
    BRANCH = "localstack",
    BUCKET = "localstack"
  }
}

resource aws_lambda_event_source_mapping certificate_generation {
  event_source_arn = module.cert_gen_sqs.queue_arn
  function_name    = module.certificate_generation_lambda.arn
}
