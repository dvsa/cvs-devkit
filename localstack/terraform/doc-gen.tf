locals {
  doc_gen_service_map = {
    name           = "cvs-localstack-doc-gen",
    bucket_name    = "cvs-services",
    object_key     = "cvs-svc-doc-gen/latest.zip",
    object_version = "localstack"
    handler        = "uk.gov.dvsa.PdfGenerator"
    description    = "cvs-svc-doc-gen",
    repo           = "cvs-svc-doc-gen",
    runtime        = "java11"
    timeout        = 30,
    memory         = 3008
  }
}

module doc_gen_lambda {
  source                 = "./lambda"
  service_map            = local.doc_gen_service_map
  lambda_exec_role_arn   = module.iam.lambda_exec_role_arn
  additional_env_vars = {
    BRANCH = "localstack"
  }
}