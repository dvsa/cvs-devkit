resource aws_iam_role lambda_exec {
  name               = "lambda_exec_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_exec_role.json
}

resource aws_iam_role s3_pushrole {
  name               = "APIGW_pushtos3_role"
  assume_role_policy = data.aws_iam_policy_document.apigw.json
}