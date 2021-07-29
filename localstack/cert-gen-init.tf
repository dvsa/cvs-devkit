//locals {
//  cert_gen_init_service_map = {
//    name           = "cvs-localstack-cert-gen-init",
//    bucket_name    = "cvs-services",
//    object_key     = "cvs-svc-cert-gen-init/latest.zip",
//    object_version = "localstack"
//    handler        = "handler.handler",
//    description    = "cvs-svc-cert-gen-init",
//    repo           = "cvs-svc-cert-gen-init",
//    runtime        = "nodejs14.x"
//    timeout        = 30,
//    memory         = 128
//  }
//}
//
//module cert_gen_init_lambda {
//  source                 = "./lambda"
//  service_map            = local.cert_gen_init_service_map
//  lambda_exec_role_arn   = module.iam.lambda_exec_role_arn
//  additional_env_vars = {
//    BRANCH = "localstack"
//    ENDPOINT = "http://${LOCALSTACK_HOSTNAME}:4566"
//  }
//}
//
//
//resource aws_lambda_permission cert-gen-init {
//  statement_id  = "AllowExecutionFromAPIGateway"
//  action        = "lambda:InvokeFunction"
//  function_name = module.cert_gen_init_lambda.function_name
//  principal     = "apigateway.amazonaws.com"
//  source_arn    = "arn:aws:execute-api:eu-west-1:000000000000:${module.api.apigw_id}/*/*/*"
//}
//
//resource aws_lambda_event_source_mapping cert_gen_init {
//  batch_size        = 10
//  event_source_arn  = module.test_results_dynamo.stream_arn
//  function_name     = module.cert_gen_init_lambda.arn
//  starting_position = "LATEST"
//}