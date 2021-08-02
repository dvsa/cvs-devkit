data aws_iam_policy_document lambda_exec_role {

  statement {
    sid    = "AllowReadSecretManagerSecrets"
    effect = "Allow"

    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "AllowInvokeLambda"
    effect = "Allow"

    actions = [
      "lambda:InvokeFunction",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "AllowCloudWatchMetrics"
    effect = "Allow"

    actions = [
      "cloudwatch:PutMetricData",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowDynamoDBActions"
    effect = "Allow"

    actions = [
      "dynamodb:Query",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:GetShardIterator",
      "dynamodb:DescribeStream",
      "dynamodb:ListStreams",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "AllowLogStreams"
    effect = "Allow"

    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "logs:FilterLogEvents",
    ]

    resources = ["*"]
  }
}

data aws_iam_policy_document apigw {

  statement {
    sid     = "AllowAPIGWToAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}