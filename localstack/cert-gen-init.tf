locals {
  cert_gen_init_service_map = {
    name           = "cvs-localstack-cert-gen-init",
    bucket_name    = "cvs-services",
    object_key     = "cvs-tsk-cert-gen-init/latest.zip",
    object_version = "localstack"
    handler        = "handler.handler",
    description    = "cvs-tsk-cert-gen-init",
    repo           = "cvs-tsk-cert-gen-init",
    runtime        = "nodejs14.x"
    timeout        = 30,
    memory         = 128
  }
}

module cert_gen_init_lambda {
  source                 = "./lambda"
  service_map            = local.cert_gen_init_service_map
  lambda_exec_role_arn   = module.iam.lambda_exec_role_arn
  additional_env_vars = {
    BRANCH = "localstack"
    ENDPOINT = "sqs.eu-west-1.amazonaws.com"
  }
}

module cert_gen_sqs {
  source       = "./sqs"
  service_name = "cert-gen-localstack-queue"
}

module update_status_sqs {
  source       = "./sqs"
  service_name = "update-status-localstack-queue"
}

