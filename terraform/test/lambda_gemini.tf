data "archive_file" "golang_sftp_package" {  
  type = "zip" 
  source_file = "${path.module}/code/sftp_gemini.go" 
  output_path = "${path.module}/code/pkg/bootstrap.zip"
}

resource "aws_lambda_function" "lambda_go" {
  function_name = "lambda-go-example"
#   source_file = "${path.module}/code/sftp_gemini.go" 
  runtime = "go1.x"
  handler = "main"
  role = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/code/pkg/bootstrap.zip"
#   code {
#     zip_file = "${file("${path.module}/code/pkg/bootstrap.zip")}"
#   }

  environment {
    variables = {
      GOOS = "linux"
      GOARCH = "amd64"
      destination_bucket = "sample-s3"
    }
  }

  tags = {
    Name = "lambda-go-example"
  }
}

# resource "aws_lambda_permission" "lambda_permission" {
#   statement_id = "AllowExecutionFromCloudWatchEvents"
#   action = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.lambda_go.arn
#   principal = "events.amazonaws.com"
#   source_arn = "arn:aws:events:*:*:rule/lambda-go-example-rule"
# }

resource "aws_lambda_permission" "allow_s3_sftp" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_go.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.source_s3.arn
}

resource "aws_s3_bucket_notification" "bucket_notification_sftp" {
  bucket = aws_s3_bucket.source_s3.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_go.arn
    events              = ["s3:ObjectCreated:*","s3:*:*"]
    filter_prefix       = "uploads/"
    filter_suffix       = ".txt"
  }
}
