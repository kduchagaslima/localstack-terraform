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

resource "aws_iam_user" "test" {
  name = "test"
  path = "/test/"
}

resource "aws_iam_access_key" "test" {
  user = aws_iam_user.test.name
}

# output "AWS_ACCESS_KEY_ID" {
#   value = aws_iam_user.test.unique_id
# }

# output "AWS_SECRET_ACCESS_KEY" {
#   value = aws_iam_access_key.test.secret
#   sensitive = true
# }
