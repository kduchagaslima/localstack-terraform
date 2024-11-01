resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_full_access_policy"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_full_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_user" "localstack" {
  name = "localstack"
  path = "/localstack/"
}

resource "aws_iam_access_key" "localstack" {
  user = aws_iam_user.localstack.name
}

output "AWS_ACCESS_KEY_ID" {
  value = aws_iam_user.localstack.unique_id
}

output "AWS_SECRET_ACCESS_KEY" {
  value = aws_iam_access_key.localstack.secret
  sensitive = true
}

resource "aws_iam_role" "firehose_role" {
  name = "GrafanaAWSLogsRoleFirehose"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "firehose_policy" {
  name = "S3AndLogs"
  role = aws_iam_role.firehose_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

