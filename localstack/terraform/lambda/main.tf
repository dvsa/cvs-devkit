data "aws_s3_bucket_object" "object" {
  bucket = var.service_map.bucket_name
  key    = var.service_map.object_key
}

output test {
  value = data.aws_s3_bucket_object.object.metadata
}

resource aws_lambda_function service {
  function_name    = var.service_map.name
  s3_bucket        = var.service_map.bucket_name
  s3_key           = var.service_map.object_key
  handler          = var.service_map.handler
  runtime          = var.service_map.runtime
  role             = var.lambda_exec_role_arn
  memory_size      = var.service_map.memory
  timeout          = var.service_map.timeout
  source_code_hash = data.aws_s3_bucket_object.object.metadata["Sha"]

  environment {
    variables = var.additional_env_vars
  }
  depends_on = [aws_cloudwatch_log_group.log]
}
resource "aws_cloudwatch_log_group" "log" {
  name = "/aws/lambda/${var.service_map.name}"

  tags = {
    Environment = "localstack"
    Application = var.service_map.name
  }
}