resource aws_api_gateway_rest_api apigw {
  name     = "localstack"
  body     = data.template_file.api_spec.rendered
}

resource aws_iam_role invocation_role {
  name     = "localstack_api_gateway_auth_invocation"
  path     = "/"
  assume_role_policy = data.aws_iam_policy_document.allow_apigw_assume.json
}

data aws_iam_policy_document allow_apigw_assume {
  statement {
    sid     = "AllowApiGWToAssumeThisRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["apigateway.amazonaws.com"]
      type        = "Service"
    }
  }
}

data aws_iam_policy_document allow_invoke_auth {
  statement {
    effect    = "Allow"
    actions   = ["Lambda:InvokeFunction"]
    resources = ["arn:aws:lambda:local:000000000000:function:authoriser-*"]
  }
}

resource aws_iam_role_policy invocation_policy {
  role     = aws_iam_role.invocation_role.id
  policy   = data.aws_iam_policy_document.allow_invoke_auth.json
}

locals {
  api_spec_ver = "0.0.1"
}

data template_file api_spec {
  template = file("swagger/api.json")
}

resource aws_api_gateway_deployment deployment {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  triggers = {
    spec = md5(data.template_file.api_spec.rendered)
  }
}

resource aws_api_gateway_stage stage {
  rest_api_id          =  aws_api_gateway_rest_api.apigw.id
  deployment_id        =  aws_api_gateway_deployment.deployment.id
  stage_name           = "localstack"
}

resource aws_api_gateway_method_settings settings {
  rest_api_id = aws_api_gateway_stage.stage.rest_api_id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  method_path = "*/*"

  settings {
    logging_level      = "INFO"
    metrics_enabled    = true
  }
}

resource aws_api_gateway_base_path_mapping main {
  api_id      = aws_api_gateway_stage.stage.rest_api_id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  domain_name = "localstack"
  base_path   = aws_api_gateway_stage.stage.stage_name
}

