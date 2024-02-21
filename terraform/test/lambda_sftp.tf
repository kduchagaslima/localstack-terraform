
data "archive_file" "python_sftp_package" {  
  type = "zip"  
#   source_file = "${path.module}/code/sftp_function.py" 
  # source_file = "${path.module}/code/sftp_function.go" 
  source_file = "${path.module}/code/sftp_gemini.go" 
  output_path = "${path.module}/code/pkg/bootstrap.zip"
}

# resource "aws_lambda_layer_version" "lambda_layer" {
# #   filename   = "lambda_layer_payload.zip"
#   layer_name = "paramiko_lib"
#   s3_bucket = "python-library"
#   s3_key = "paramiko.zip"

#   compatible_runtimes = ["python3.7"]
# }

resource "aws_lambda_function" "sftp_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/code/pkg/bootstrap.zip"
  source_code_hash = data.archive_file.python_sftp_package.output_base64sha256
  function_name = "sftp_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "main.go"
#   handler       = "sftp_function.lambda_handler"
#   layers = [aws_lambda_layer_version.lambda_layer.arn]
  runtime = "provided.al2023"
  tags = {
    Environment = "dev"
    Management = "Terraform"
  }

  environment {
    variables = {
      destination_bucket = "sample-s3"
    }
  }
}

resource "aws_lambda_permission" "allow_s3_sftp" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sftp_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.source_s3.arn
}

resource "aws_s3_bucket_notification" "bucket_notification_sftp" {
  bucket = aws_s3_bucket.source_s3.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.sftp_lambda.arn
    events              = ["s3:ObjectCreated:*","s3:*:*"]
    filter_prefix       = "uploads/"
    filter_suffix       = ".txt"
  }
}